# grouped-gemm-asm

ASM optimization harness for FP8 tensorwise grouped GEMM kernels (GPT-OSS 20B MoE).

Plug in a `.co` (or `.s` to auto-assemble), get correctness vs Triton reference + benchmark.

## Usage

```bash
# Inside rocm/primus:v26.2 Docker on MI355X

# Test reference .co against Triton (should match perfectly)
python3 bench.py --kernel kernels/persistent_gemm_ref.co --site all_fwd

# Benchmark Triton baseline only
python3 bench.py --triton-only --site all

# Test a new hand-written kernel
python3 bench.py --kernel kernels/my_fast_gemm.s --site gate_up_fwd

# Benchmark custom vs Triton
python3 bench.py --kernel kernels/my_fast_gemm.co --site gate_up_fwd --benchmark
```

## Call Sites

| Site | Kind | Shape | MFMA | Kernel |
|------|------|-------|------|--------|
| gate_up_fwd | fwd | M=131072 K=2880 N=5760 | 16x16x128_f8f6f4 | persistent |
| down_fwd | fwd | M=131072 K=2880 N=2880 | 16x16x128_f8f6f4 | persistent |
| down_dgrad | dgrad | M=131072 K=2880 N=2880 | 16x16x128_f8f6f4 | persistent |
| gate_up_dgrad | dgrad | M=131072 K=5760 N=2880 | 16x16x128_f8f6f4 | persistent |
| down_wgrad | wgrad | M=131072 OUT_M=2880 OUT_N=2880 | 16x16x32_fp8_bf8 | variable_k |
| gate_up_wgrad | wgrad | M=131072 OUT_M=2880 OUT_N=5760 | 16x16x32_fp8_bf8 | variable_k |

## Performance (MI355X, gfx950, Primus Turbo v26.2)

E=32, M_total=131072, F=2880, 2F=5760. All correctness PASS (cos=1.0000, bit-identical).

| Site | Shape | Dtypes | Triton (ms) | Ref ASM (ms) | TFLOPS |
|------|-------|--------|-------------|--------------|--------|
| gate_up_fwd | M=131072 K=2880 N=5760 | e4m3 x e4m3 | 2.443 | 2.642 | 1645.9 |
| down_fwd | M=131072 K=2880 N=2880 | e4m3 x e4m3 | 1.312 | 1.412 | 1540.0 |
| down_dgrad | M=131072 K=2880 N=2880 | e5m2 x e4m3 | 1.307 | 1.408 | 1544.4 |
| gate_up_dgrad | M=131072 K=5760 N=2880 | e5m2 x e4m3 | 2.155 | 2.275 | 1911.9 |
| down_wgrad | M=131072 OM=2880 ON=2880 | e4m3 x e5m2 | 2.197 | 2.284 | 951.9 |
| gate_up_wgrad | M=131072 OM=2880 ON=5760 | e4m3 x e5m2 | 3.885 | 4.055 | 1072.4 |
| **TOTAL** | | | **13.298** | **14.076** | **1390.3** |

Ref ASM = same .co launched via HIP ctypes (~5% overhead vs Triton's compiled C launcher).

## Reference Kernels

`kernels/` contains Triton-compiled reference `.co` files from Primus Turbo v26.2 on MI355X (gfx950):
- `persistent_gemm_ref.co` — fwd sites (e4m3 x e4m3), 64x v_mfma_f32_16x16x128_f8f6f4, 248 VGPRs
- `persistent_gemm_dgrad_ref.co` — dgrad sites (e5m2 x e4m3), same structure, different FP8 encoding
- `variable_k_gemm_ref.co` — wgrad sites, 128x v_mfma_f32_16x16x32_fp8_bf8, 221 VGPRs

## Arg Layout

### Persistent kernel (fwd/dgrad)
Runtime args: `A, B, C, A_scale, B_scale, group_offs, G, N, K, stride_am, stride_bg, stride_bn, stride_cm, stride_cn`

### Variable-K kernel (wgrad)
Runtime args: `LHS, RHS, C, LHS_scale, RHS_scale, group_offs, G, OUT_M, OUT_N, stride_lhs_m, stride_rhs_m, stride_cg, stride_cm, stride_cn`
