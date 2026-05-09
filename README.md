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

## Reference Kernels

`kernels/` contains the Triton-compiled reference `.co` and disassembled `.s` from Primus Turbo v26.2 on MI355X (gfx950).

## Arg Layout

### Persistent kernel (fwd/dgrad)
Runtime args: `A, B, C, A_scale, B_scale, group_offs, G, N, K, stride_am, stride_bg, stride_bn, stride_cm, stride_cn`

### Variable-K kernel (wgrad)
Runtime args: `LHS, RHS, C, LHS_scale, RHS_scale, group_offs, G, OUT_M, OUT_N, stride_lhs_m, stride_rhs_m, stride_cg, stride_cm, stride_cn`
