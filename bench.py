#!/usr/bin/env python3
"""Grouped GEMM ASM harness — plug in a .co, get correctness + perf.

Takes a compiled code object (.co / .hsaco) and launches it via HIP ctypes
with the same inputs + arg layout as Primus Turbo's Triton kernels. Compares
output against the Triton reference for correctness and benchmarks both.

Usage:
  # Test reference .co against Triton (should match perfectly)
  python3 bench.py --kernel kernels/persistent_gemm_ref.co --site gate_up_fwd

  # Benchmark all fwd sites with a custom kernel
  python3 bench.py --kernel my_gemm.co --site all_fwd --benchmark

  # Benchmark all wgrad sites
  python3 bench.py --kernel my_vark.co --site all_wgrad --benchmark

  # Assemble .s -> .co, then test
  python3 bench.py --kernel my_gemm.s --site gate_up_fwd

  # Just run Triton reference benchmarks (no custom kernel)
  python3 bench.py --site all --triton-only

Call sites (GPT-OSS 20B MoE, E=32):
  FWD:   gate_up_fwd   (e4m3 x e4m3) M=131072 K=2880 N=5760  [persistent kernel]
         down_fwd       (e4m3 x e4m3) M=131072 K=2880 N=2880  [persistent kernel]
  DGRAD: down_dgrad     (e5m2 x e4m3) M=131072 K=2880 N=2880  [persistent kernel]
         gate_up_dgrad  (e5m2 x e4m3) M=131072 K=5760 N=2880  [persistent kernel]
  WGRAD: down_wgrad     (e4m3 x e5m2) M=131072 OUT_M=2880 OUT_N=2880 [variable-K kernel]
         gate_up_wgrad  (e4m3 x e5m2) M=131072 OUT_M=2880 OUT_N=5760 [variable-K kernel]
"""
import argparse
import ctypes
import math
import os
import struct
import subprocess
import sys
import time

import torch

# ── HIP ctypes bindings ─────────────────────────────────────────────────────

_hip = None

def _load_hip():
    global _hip
    if _hip is not None:
        return _hip
    for name in ["libamdhip64.so", "libamdhip64.so.6"]:
        try:
            _hip = ctypes.CDLL(name)
            break
        except OSError:
            continue
    if _hip is None:
        rocm = os.environ.get("ROCM_PATH", "/opt/rocm")
        _hip = ctypes.CDLL(os.path.join(rocm, "lib", "libamdhip64.so"))

    _hip.hipModuleLoadData.restype = ctypes.c_int
    _hip.hipModuleLoadData.argtypes = [
        ctypes.POINTER(ctypes.c_void_p),
        ctypes.c_void_p,
    ]
    _hip.hipModuleGetFunction.restype = ctypes.c_int
    _hip.hipModuleGetFunction.argtypes = [
        ctypes.POINTER(ctypes.c_void_p),
        ctypes.c_void_p,
        ctypes.c_char_p,
    ]
    _hip.hipModuleLaunchKernel.restype = ctypes.c_int
    _hip.hipModuleLaunchKernel.argtypes = [
        ctypes.c_void_p,  # function
        ctypes.c_uint, ctypes.c_uint, ctypes.c_uint,  # grid
        ctypes.c_uint, ctypes.c_uint, ctypes.c_uint,  # block
        ctypes.c_uint,  # shared mem
        ctypes.c_void_p,  # stream
        ctypes.POINTER(ctypes.c_void_p),  # kernelParams
        ctypes.c_void_p,  # extra
    ]
    _hip.hipDeviceSynchronize.restype = ctypes.c_int
    _hip.hipModuleUnload.restype = ctypes.c_int
    _hip.hipModuleUnload.argtypes = [ctypes.c_void_p]
    _hip.hipGetErrorString.restype = ctypes.c_char_p
    _hip.hipGetErrorString.argtypes = [ctypes.c_int]
    return _hip


def _check_hip(err, msg=""):
    if err != 0:
        hip = _load_hip()
        errstr = hip.hipGetErrorString(err)
        raise RuntimeError(f"HIP error {err} ({errstr}): {msg}")


def load_kernel(co_path, kernel_name=None):
    """Load a .co file and return (module, function, detected_kernel_name)."""
    hip = _load_hip()

    with open(co_path, "rb") as f:
        data = f.read()

    module = ctypes.c_void_p()
    _check_hip(hip.hipModuleLoadData(ctypes.byref(module), data), f"loading {co_path}")

    if kernel_name is None:
        kernel_name = _detect_kernel_name(co_path, data)

    func = ctypes.c_void_p()
    _check_hip(
        hip.hipModuleGetFunction(ctypes.byref(func), module, kernel_name.encode()),
        f"getting function '{kernel_name}'",
    )
    return module, func, kernel_name


def _detect_kernel_name(co_path, data):
    """Try llvm-readelf to find the kernel symbol, fall back to common names."""
    try:
        result = subprocess.run(
            ["llvm-readelf", "-s", co_path],
            capture_output=True, text=True, timeout=5,
        )
        if result.returncode == 0:
            for line in result.stdout.split("\n"):
                if "FUNC" in line and "GLOBAL" in line:
                    parts = line.split()
                    name = parts[-1]
                    if name.startswith("_grouped"):
                        return name
    except (FileNotFoundError, subprocess.TimeoutExpired):
        pass
    # fall back: scan ELF for known symbol names
    for name in [b"_grouped_fp8_persistent_gemm_kernel", b"_grouped_variable_k_gemm_kernel"]:
        if name in data:
            return name.decode()
    raise RuntimeError(f"Cannot detect kernel name in {co_path}. Pass --kernel-name explicitly.")


def unload_kernel(module):
    hip = _load_hip()
    hip.hipModuleUnload(module)


# ── Shapes ──────────────────────────────────────────────────────────────────

E = 32
M_TOTAL = 131072
F_DIM = 2880
F2_DIM = 5760

CALL_SITES = {
    "gate_up_fwd": {
        "kernel_type": "persistent",
        "M": M_TOTAL, "K": F_DIM, "N": F2_DIM, "E": E,
        "a_dtype": torch.float8_e4m3fn, "b_dtype": torch.float8_e4m3fn,
        "trans_b": True,
        "desc": "x @ W_gu (gate||up fused)",
    },
    "down_fwd": {
        "kernel_type": "persistent",
        "M": M_TOTAL, "K": F_DIM, "N": F_DIM, "E": E,
        "a_dtype": torch.float8_e4m3fn, "b_dtype": torch.float8_e4m3fn,
        "trans_b": True,
        "desc": "swiglu @ W_d",
    },
    "down_dgrad": {
        "kernel_type": "persistent",
        "M": M_TOTAL, "K": F_DIM, "N": F_DIM, "E": E,
        "a_dtype": torch.float8_e5m2, "b_dtype": torch.float8_e4m3fn,
        "trans_b": True,
        "desc": "dy_d @ W_d^T",
    },
    "gate_up_dgrad": {
        "kernel_type": "persistent",
        "M": M_TOTAL, "K": F2_DIM, "N": F_DIM, "E": E,
        "a_dtype": torch.float8_e5m2, "b_dtype": torch.float8_e4m3fn,
        "trans_b": True,
        "desc": "dy_gu @ W_gu^T (K=5760)",
    },
    "down_wgrad": {
        "kernel_type": "variable_k",
        "M": M_TOTAL, "OUT_M": F_DIM, "OUT_N": F_DIM, "E": E,
        "a_dtype": torch.float8_e4m3fn, "b_dtype": torch.float8_e5m2,
        "desc": "dW_d = swiglu^T @ dy_d",
    },
    "gate_up_wgrad": {
        "kernel_type": "variable_k",
        "M": M_TOTAL, "OUT_M": F_DIM, "OUT_N": F2_DIM, "E": E,
        "a_dtype": torch.float8_e4m3fn, "b_dtype": torch.float8_e5m2,
        "desc": "dW_gu = x^T @ dy_gu",
    },
}

SITE_GROUPS = {
    "all": list(CALL_SITES.keys()),
    "all_fwd": ["gate_up_fwd", "down_fwd", "down_dgrad", "gate_up_dgrad"],
    "all_wgrad": ["down_wgrad", "gate_up_wgrad"],
}


# ── Input generation ────────────────────────────────────────────────────────

def make_group_lens(E, M_total, seed=42):
    rng = torch.Generator().manual_seed(seed)
    raw = torch.empty(E).exponential_(generator=rng)
    raw = raw / raw.sum() * M_total
    lens = raw.long()
    lens[-1] = M_total - lens[:-1].sum()
    assert lens.sum() == M_total and (lens > 0).all()
    return lens.cuda()


def make_group_offs(group_lens):
    offs = torch.zeros(len(group_lens) + 1, dtype=torch.int64, device=group_lens.device)
    offs[1:] = torch.cumsum(group_lens.long(), dim=0)
    return offs


def make_fp8_tensor(shape, dtype, device="cuda"):
    t = torch.randn(shape, device=device, dtype=torch.bfloat16)
    return t.to(dtype)


def get_num_cus():
    props = torch.cuda.get_device_properties(0)
    return props.multi_processor_count


# ── Triton reference runners ────────────────────────────────────────────────

_primus_loaded = False
_triton_fwd = None
_triton_vark = None

def _load_primus():
    global _primus_loaded, _triton_fwd, _triton_vark
    if _primus_loaded:
        return
    from primus_turbo.triton.grouped_gemm.grouped_gemm_fp8_kernel import (
        grouped_gemm_fp8_tensorwise_triton_kernel,
        grouped_gemm_fp8_tensorwise_variable_k_triton_kernel,
    )
    _triton_fwd = grouped_gemm_fp8_tensorwise_triton_kernel
    _triton_vark = grouped_gemm_fp8_tensorwise_variable_k_triton_kernel
    _primus_loaded = True


def run_triton_ref(site_name, site, group_offs):
    """Run the Triton reference and return the output tensor."""
    _load_primus()
    torch.manual_seed(42)
    if site["kernel_type"] == "persistent":
        M, K, N = site["M"], site["K"], site["N"]
        a = make_fp8_tensor((M, K), site["a_dtype"])
        b = make_fp8_tensor((E, N, K) if site["trans_b"] else (E, K, N), site["b_dtype"])
        a_scale = torch.tensor(0.1, dtype=torch.float32, device="cuda")
        b_scale = torch.tensor(0.1, dtype=torch.float32, device="cuda")
        out = _triton_fwd(a, b, a_scale, b_scale, group_offs, trans_b=site["trans_b"])
        return a, b, a_scale, b_scale, out
    else:
        M, OUT_M, OUT_N = site["M"], site["OUT_M"], site["OUT_N"]
        lhs = make_fp8_tensor((M, OUT_M), site["a_dtype"])
        rhs = make_fp8_tensor((M, OUT_N), site["b_dtype"])
        lhs_scale = torch.tensor(0.1, dtype=torch.float32, device="cuda")
        rhs_scale = torch.tensor(0.1, dtype=torch.float32, device="cuda")
        out = _triton_vark(lhs, rhs, lhs_scale, rhs_scale, group_offs)
        return lhs, rhs, lhs_scale, rhs_scale, out


# ── HIP kernel launch (matching Triton arg layout) ─────────────────────────
#
# Triton compiles constexpr args as constants baked into the binary.
# Only runtime args are passed via the kernel arg buffer.
#
# Persistent kernel runtime args (Primus v26.2):
#   A, B, C, A_scale_ptr, B_scale_ptr, group_offs_ptr,
#   G, N, K, stride_am, stride_bg, stride_bn, stride_cm, stride_cn
#   (14 args: 6 pointers + 8 int32s)
#
# Variable-K kernel runtime args (Primus v26.2):
#   LHS, RHS, C, LHS_scale_ptr, RHS_scale_ptr, group_offs_ptr,
#   G, OUT_M, OUT_N, stride_lhs_m, stride_rhs_m, stride_cg, stride_cm, stride_cn
#   (14 args: 6 pointers + 8 int32s)


def _ptr(tensor):
    return ctypes.c_void_p(tensor.data_ptr())


def _i32(val):
    return ctypes.c_int32(int(val))


def _pack_args(*args):
    """Pack args into a (ctypes.c_void_p * N) array for hipModuleLaunchKernel."""
    arr = (ctypes.c_void_p * len(args))()
    storage = []
    for i, a in enumerate(args):
        if isinstance(a, ctypes.c_void_p):
            p = ctypes.c_uint64(a.value if a.value else 0)
        elif isinstance(a, ctypes.c_int32):
            p = ctypes.c_int32(a.value)
        else:
            raise TypeError(f"Unexpected arg type: {type(a)}")
        storage.append(p)
        arr[i] = ctypes.cast(ctypes.pointer(storage[-1]), ctypes.c_void_p)
    return arr, storage


def launch_persistent_kernel(func, a, b, out, a_scale, b_scale,
                              group_offs, G, N, K,
                              num_sms, shared_mem=65536):
    """Launch persistent grouped GEMM .co with Triton's arg layout (Primus v26.2)."""
    hip = _load_hip()

    stride_am = a.stride(0)
    stride_bg = b.stride(0)
    stride_bn = b.stride(1)  # N-stride (for trans_b=True, b is [E,N,K], stride(1)=K)
    stride_cm = out.stride(0)
    stride_cn = out.stride(1)

    # Triton appends global_scratch (=0) and profile_scratch (=0) after user args
    args = [
        _ptr(a), _ptr(b), _ptr(out),
        _ptr(a_scale), _ptr(b_scale),
        _ptr(group_offs),
        _i32(G), _i32(N), _i32(K),
        _i32(stride_am), _i32(stride_bg), _i32(stride_bn),
        _i32(stride_cm), _i32(stride_cn),
        ctypes.c_void_p(0),  # global_scratch
        ctypes.c_void_p(0),  # profile_scratch
    ]
    packed, _storage = _pack_args(*args)

    _check_hip(
        hip.hipModuleLaunchKernel(
            func,
            num_sms, 1, 1,   # grid
            512, 1, 1,       # block (8 warps * 64 threads)
            shared_mem,
            None,            # default stream
            packed,
            None,
        ),
        "launching persistent kernel",
    )


def launch_variable_k_kernel(func, lhs, rhs, out, lhs_scale, rhs_scale,
                               group_offs, G, OUT_M, OUT_N,
                               num_sms, shared_mem=65536):
    """Launch variable-K grouped GEMM .co with Triton's arg layout."""
    hip = _load_hip()

    stride_lhs_m = lhs.stride(0)
    stride_rhs_m = rhs.stride(0)
    stride_cg = out.stride(0)
    stride_cm = out.stride(1)
    stride_cn = out.stride(2)

    args = [
        _ptr(lhs), _ptr(rhs), _ptr(out),
        _ptr(lhs_scale), _ptr(rhs_scale),
        _ptr(group_offs),
        _i32(G), _i32(OUT_M), _i32(OUT_N),
        _i32(stride_lhs_m), _i32(stride_rhs_m),
        _i32(stride_cg), _i32(stride_cm), _i32(stride_cn),
        ctypes.c_void_p(0),  # global_scratch
        ctypes.c_void_p(0),  # profile_scratch
    ]
    packed, _storage = _pack_args(*args)

    _check_hip(
        hip.hipModuleLaunchKernel(
            func,
            num_sms, 1, 1,
            512, 1, 1,
            shared_mem,
            None,
            packed,
            None,
        ),
        "launching variable-K kernel",
    )


# ── Assemble .s -> .co ─────────────────────────────────────────────────────

def assemble_if_needed(path):
    """If path is .s, assemble to .co and return .co path. Otherwise return as-is."""
    if not path.endswith(".s"):
        return path

    co_path = path.replace(".s", ".co")
    print(f"Assembling {path} -> {co_path}")

    # assemble .s -> .o
    obj_path = path.replace(".s", ".o")
    result = subprocess.run(
        ["llvm-mc", "-triple=amdgcn-amd-amdhsa", "-mcpu=gfx950",
         "-filetype=obj", "-o", obj_path, path],
        capture_output=True, text=True,
    )
    if result.returncode != 0:
        # try with /opt/rocm path
        result = subprocess.run(
            ["/opt/rocm/llvm/bin/llvm-mc", "-triple=amdgcn-amd-amdhsa", "-mcpu=gfx950",
             "-filetype=obj", "-o", obj_path, path],
            capture_output=True, text=True,
        )
    if result.returncode != 0:
        raise RuntimeError(f"Assembly failed:\n{result.stderr}")

    # link .o -> .co
    result = subprocess.run(
        ["ld.lld", "-shared", "-o", co_path, obj_path],
        capture_output=True, text=True,
    )
    if result.returncode != 0:
        result = subprocess.run(
            ["/opt/rocm/llvm/bin/ld.lld", "-shared", "-o", co_path, obj_path],
            capture_output=True, text=True,
        )
    if result.returncode != 0:
        raise RuntimeError(f"Linking failed:\n{result.stderr}")

    print(f"  -> {co_path} ({os.path.getsize(co_path):,} bytes)")
    return co_path


# ── ELF info ────────────────────────────────────────────────────────────────

def print_kernel_info(co_path):
    """Print basic info about a .co file."""
    size = os.path.getsize(co_path)
    print(f"  File: {co_path} ({size:,} bytes)")

    try:
        result = subprocess.run(
            ["llvm-readelf", "-n", co_path],
            capture_output=True, text=True, timeout=5,
        )
        if result.returncode != 0:
            result = subprocess.run(
                ["/opt/rocm/llvm/bin/llvm-readelf", "-n", co_path],
                capture_output=True, text=True, timeout=5,
            )
        if result.returncode == 0:
            for line in result.stdout.split("\n"):
                for key in ["vgpr_count", "sgpr_count", "group_segment", "wavefront_size",
                            "max_flat_workgroup", "spill_count"]:
                    if key in line:
                        print(f"  {line.strip()}")
    except (FileNotFoundError, subprocess.TimeoutExpired):
        pass

    # instruction count from disassembly
    try:
        result = subprocess.run(
            ["llvm-objdump", "-d", "--mcpu=gfx950", co_path],
            capture_output=True, text=True, timeout=30,
        )
        if result.returncode != 0:
            result = subprocess.run(
                ["/opt/rocm/llvm/bin/llvm-objdump", "-d", "--mcpu=gfx950", co_path],
                capture_output=True, text=True, timeout=30,
            )
        if result.returncode == 0:
            lines = result.stdout.strip().split("\n")
            instrs = [l for l in lines if l.strip() and "\t" in l
                      and not l.strip().startswith("//") and ":" in l.split("\t")[0]]
            mfma = sum(1 for l in instrs if "v_mfma" in l)
            nops = sum(1 for l in instrs if "s_nop" in l)
            print(f"  Instructions: {len(instrs)}  (MFMA: {mfma}, NOP: {nops})")
    except (FileNotFoundError, subprocess.TimeoutExpired):
        pass


# ── Correctness ─────────────────────────────────────────────────────────────

def test_correctness(co_path, site_names, kernel_name=None):
    print("=" * 80)
    print("CORRECTNESS — custom .co vs Triton reference")
    print("=" * 80)
    print_kernel_info(co_path)
    print()

    module, func, kname = load_kernel(co_path, kernel_name)
    print(f"  Kernel symbol: {kname}")

    group_lens = make_group_lens(E, M_TOTAL)
    group_offs = make_group_offs(group_lens)
    num_sms = get_num_cus()

    for site_name in site_names:
        site = CALL_SITES[site_name]
        print(f"\n--- {site_name}: {site['desc']} ---")

        # get Triton reference output + inputs
        inputs = run_triton_ref(site_name, site, group_offs)

        if site["kernel_type"] == "persistent":
            a, b, a_scale, b_scale, ref_out = inputs
            M, K, N = site["M"], site["K"], site["N"]

            # allocate output for custom kernel
            custom_out = torch.zeros_like(ref_out)

            launch_persistent_kernel(
                func, a, b, custom_out, a_scale, b_scale,
                group_offs, E, N, K, num_sms,
            )
            _check_hip(_load_hip().hipDeviceSynchronize(), "sync")

        else:
            lhs, rhs, lhs_scale, rhs_scale, ref_out = inputs
            OUT_M, OUT_N = site["OUT_M"], site["OUT_N"]

            custom_out = torch.zeros(E, OUT_M, OUT_N, device="cuda", dtype=ref_out.dtype)

            launch_variable_k_kernel(
                func, lhs, rhs, custom_out, lhs_scale, rhs_scale,
                group_offs, E, OUT_M, OUT_N, num_sms,
            )
            _check_hip(_load_hip().hipDeviceSynchronize(), "sync")

        # compare
        af = custom_out.float().flatten()
        bf = ref_out.float().flatten()
        cos = (torch.dot(af, bf) / (af.norm() * bf.norm() + 1e-12)).item()
        max_diff = (custom_out.float() - ref_out.float()).abs().max().item()
        status = "PASS" if cos >= 0.999 else "FAIL"
        print(f"  [{status}] cos={cos:.6f}  max_diff={max_diff:.6f}")

    unload_kernel(module)


# ── Benchmark ───────────────────────────────────────────────────────────────

def benchmark(co_path, site_names, kernel_name=None, warmup=20, iters=100,
              triton_only=False):
    print("=" * 80)
    if triton_only:
        print("BENCHMARK — Triton reference only")
    else:
        print("BENCHMARK — custom .co vs Triton reference")
        print_kernel_info(co_path)
    print(f"GPU: {torch.cuda.get_device_name(0)}")
    print(f"E={E}, M_total={M_TOTAL}, F={F_DIM}, 2F={F2_DIM}")
    print(f"Warmup: {warmup}, Iters: {iters}")
    print("=" * 80)

    module, func, kname = None, None, None
    if not triton_only:
        module, func, kname = load_kernel(co_path, kernel_name)
        print(f"  Kernel symbol: {kname}")

    group_lens = make_group_lens(E, M_TOTAL)
    group_offs = make_group_offs(group_lens)
    num_sms = get_num_cus()

    results = []

    for site_name in site_names:
        site = CALL_SITES[site_name]
        print(f"\n--- {site_name}: {site['desc']} ---")

        # ── Triton reference benchmark ──
        _load_primus()
        torch.manual_seed(42)

        if site["kernel_type"] == "persistent":
            M, K, N = site["M"], site["K"], site["N"]
            a = make_fp8_tensor((M, K), site["a_dtype"])
            b = make_fp8_tensor((E, N, K) if site["trans_b"] else (E, K, N), site["b_dtype"])
            a_scale = torch.tensor(0.1, dtype=torch.float32, device="cuda")
            b_scale = torch.tensor(0.1, dtype=torch.float32, device="cuda")
            flops = 2 * M * K * N

            def run_triton():
                return _triton_fwd(a, b, a_scale, b_scale, group_offs, trans_b=site["trans_b"])
        else:
            M, OUT_M, OUT_N = site["M"], site["OUT_M"], site["OUT_N"]
            lhs = make_fp8_tensor((M, OUT_M), site["a_dtype"])
            rhs = make_fp8_tensor((M, OUT_N), site["b_dtype"])
            lhs_scale = torch.tensor(0.1, dtype=torch.float32, device="cuda")
            rhs_scale = torch.tensor(0.1, dtype=torch.float32, device="cuda")
            flops = 2 * M * OUT_M * OUT_N

            def run_triton():
                return _triton_vark(lhs, rhs, lhs_scale, rhs_scale, group_offs)

        for _ in range(warmup):
            run_triton()
        torch.cuda.synchronize()

        start_ev = torch.cuda.Event(enable_timing=True)
        end_ev = torch.cuda.Event(enable_timing=True)
        start_ev.record()
        for _ in range(iters):
            run_triton()
        end_ev.record()
        torch.cuda.synchronize()
        triton_ms = start_ev.elapsed_time(end_ev) / iters
        triton_tflops = flops / (triton_ms * 1e-3) / 1e12

        # ── Custom kernel benchmark ──
        custom_ms, custom_tflops = None, None
        if not triton_only:
            hip = _load_hip()

            if site["kernel_type"] == "persistent":
                custom_out = torch.zeros(M, N, device="cuda", dtype=torch.bfloat16)
                def run_custom():
                    custom_out.zero_()
                    launch_persistent_kernel(
                        func, a, b, custom_out, a_scale, b_scale,
                        group_offs, E, N, K, num_sms,
                    )
            else:
                custom_out = torch.zeros(E, OUT_M, OUT_N, device="cuda", dtype=torch.bfloat16)

                def run_custom():
                    custom_out.zero_()
                    launch_variable_k_kernel(
                        func, lhs, rhs, custom_out, lhs_scale, rhs_scale,
                        group_offs, E, OUT_M, OUT_N, num_sms,
                    )

            for _ in range(warmup):
                run_custom()
                hip.hipDeviceSynchronize()

            start_ev = torch.cuda.Event(enable_timing=True)
            end_ev = torch.cuda.Event(enable_timing=True)
            start_ev.record()
            for _ in range(iters):
                run_custom()
            end_ev.record()
            torch.cuda.synchronize()
            custom_ms = start_ev.elapsed_time(end_ev) / iters
            custom_tflops = flops / (custom_ms * 1e-3) / 1e12

        results.append({
            "name": site_name,
            "flops": flops,
            "triton_ms": triton_ms,
            "triton_tflops": triton_tflops,
            "custom_ms": custom_ms,
            "custom_tflops": custom_tflops,
        })

        if custom_ms is not None:
            speedup = triton_ms / custom_ms
            print(f"  Triton:  {triton_ms:8.3f} ms  {triton_tflops:7.1f} TFLOPS")
            print(f"  Custom:  {custom_ms:8.3f} ms  {custom_tflops:7.1f} TFLOPS  ({speedup:.3f}x)")
        else:
            print(f"  Triton:  {triton_ms:8.3f} ms  {triton_tflops:7.1f} TFLOPS")

    # ── Summary table ──
    print(f"\n{'=' * 100}")
    if triton_only:
        print(f"{'Site':<20s} {'ms':>8} {'TFLOPS':>8} {'TFLOP':>8} {'% total':>8}")
        print(f"{'-' * 100}")
    else:
        print(f"{'Site':<20s} {'Triton ms':>10} {'Custom ms':>10} {'Speedup':>8} {'Custom TFLOPS':>14} {'% total':>8}")
        print(f"{'-' * 100}")

    total_triton = sum(r["triton_ms"] for r in results)
    total_custom = sum(r["custom_ms"] for r in results if r["custom_ms"]) if not triton_only else 0
    total_flops = sum(r["flops"] for r in results)

    for r in results:
        pct_triton = r["triton_ms"] / total_triton * 100
        if triton_only:
            print(f"{r['name']:<20s} {r['triton_ms']:8.3f} {r['triton_tflops']:8.1f} "
                  f"{r['flops']/1e12:8.2f} {pct_triton:7.1f}%")
        else:
            sp = r["triton_ms"] / r["custom_ms"] if r["custom_ms"] else 0
            print(f"{r['name']:<20s} {r['triton_ms']:10.3f} {r['custom_ms']:10.3f} "
                  f"{sp:8.3f}x {r['custom_tflops']:13.1f} {pct_triton:7.1f}%")

    print(f"{'-' * 100}")
    total_triton_tflops = total_flops / (total_triton * 1e-3) / 1e12
    if triton_only:
        print(f"{'TOTAL':<20s} {total_triton:8.3f} {total_triton_tflops:8.1f} "
              f"{total_flops/1e12:8.2f} {'100.0':>7s}%")
    else:
        total_custom_tflops = total_flops / (total_custom * 1e-3) / 1e12 if total_custom > 0 else 0
        total_speedup = total_triton / total_custom if total_custom > 0 else 0
        print(f"{'TOTAL':<20s} {total_triton:10.3f} {total_custom:10.3f} "
              f"{total_speedup:8.3f}x {total_custom_tflops:13.1f} {'100.0':>7s}%")
    print(f"{'=' * 100}")

    if module:
        unload_kernel(module)


# ── Main ────────────────────────────────────────────────────────────────────

def main():
    parser = argparse.ArgumentParser(
        description="Grouped GEMM ASM harness — plug in a .co, get correctness + perf",
        formatter_class=argparse.RawDescriptionHelpFormatter,
    )
    parser.add_argument("--kernel", type=str,
                        help="Path to .co (or .s to auto-assemble)")
    parser.add_argument("--kernel-name", type=str, default=None,
                        help="Kernel function name (auto-detected from ELF if omitted)")
    parser.add_argument("--site", type=str, default="all",
                        help="Call site(s): gate_up_fwd, down_fwd, etc. "
                             "Or: all, all_fwd, all_wgrad")
    parser.add_argument("--correctness", action="store_true",
                        help="Run correctness test (custom .co vs Triton)")
    parser.add_argument("--benchmark", action="store_true",
                        help="Run benchmark (custom .co vs Triton)")
    parser.add_argument("--triton-only", action="store_true",
                        help="Benchmark Triton only (no custom kernel needed)")
    parser.add_argument("--warmup", type=int, default=20)
    parser.add_argument("--iters", type=int, default=100)
    parser.add_argument("--info", action="store_true",
                        help="Print .co metadata and exit")
    args = parser.parse_args()

    # resolve site names
    if args.site in SITE_GROUPS:
        site_names = SITE_GROUPS[args.site]
    elif args.site in CALL_SITES:
        site_names = [args.site]
    else:
        print(f"Unknown site: {args.site}")
        print(f"Available: {', '.join(list(CALL_SITES.keys()) + list(SITE_GROUPS.keys()))}")
        sys.exit(1)

    # filter by kernel type if a kernel is provided
    if args.kernel and not args.triton_only:
        co_path = assemble_if_needed(args.kernel)
        _, _, kname = load_kernel(co_path, args.kernel_name)

        if args.info:
            print_kernel_info(co_path)
            return

        # auto-filter sites to match kernel type
        if "persistent" in kname:
            site_names = [s for s in site_names if CALL_SITES[s]["kernel_type"] == "persistent"]
        elif "variable_k" in kname:
            site_names = [s for s in site_names if CALL_SITES[s]["kernel_type"] == "variable_k"]

        if not site_names:
            print(f"No matching call sites for kernel '{kname}' with --site={args.site}")
            sys.exit(1)

        if not args.correctness and not args.benchmark:
            args.correctness = True
            args.benchmark = True

        if args.correctness:
            test_correctness(co_path, site_names, args.kernel_name)

        if args.benchmark:
            benchmark(co_path, site_names, args.kernel_name,
                      warmup=args.warmup, iters=args.iters)

    elif args.triton_only:
        benchmark(None, site_names, triton_only=True,
                  warmup=args.warmup, iters=args.iters)

    else:
        parser.print_help()
        print("\nPass --kernel <path> or --triton-only")
        sys.exit(1)


if __name__ == "__main__":
    main()
