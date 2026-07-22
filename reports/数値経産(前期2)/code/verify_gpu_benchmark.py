"""Verification & benchmark script for 応用課題2.6 double-integral implementations.

Compares:
  - CPU (NumPy)                          double_integral.py
  - GPU (compute shader, float64)        double_integral_gpu.py

Checks correctness against each other and the analytic solution, then times
each implementation over an increasing range of subdivisions n=m, including
"absolutely large" grids that exceed the 32-bit (n*m > ~4.29e9) index range
to exercise the uint64_t-safe indexing in the GPU shader.

Run directly:
    python3 code/verify_gpu_benchmark.py
"""

import sys
import time
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))

import numpy as np
from double_integral import double_integral_rectangle
from double_integral_gpu import double_integral_rectangle_gpu, create_gpu_context

f = lambda x, y: x ** 2 * y ** 2
a, b, c, d = 0, 10, 0, 20
analytic = (b ** 3 / 3) * (d ** 3 / 3)


def verify_correctness() -> None:
    print(f"analytic V = {analytic:.6f}")
    for n in (100, 1000, 4000):
        v_cpu = double_integral_rectangle(f, a, b, n, c, d, n)
        v_gpu = double_integral_rectangle_gpu(a, b, n, c, d, n)
        print(f"n=m={n:5d}: CPU={v_cpu:.6f}  GPU(f64)={v_gpu:.6f}  diff={abs(v_cpu - v_gpu):.3e}")


def benchmark(ns: list[int], run_cpu: bool = True) -> None:
    print("\n--- timing (GPU context reused) ---")
    ctx = create_gpu_context()
    double_integral_rectangle_gpu(a, b, 10, c, d, 10, ctx=ctx)  # warm-up (shader compile)

    for n in ns:
        total = n * n
        if run_cpu:
            t0 = time.perf_counter()
            v_cpu = double_integral_rectangle(f, a, b, n, c, d, n)
            t_cpu = time.perf_counter() - t0
        else:
            v_cpu, t_cpu = float("nan"), float("nan")

        t0 = time.perf_counter()
        v_gpu = double_integral_rectangle_gpu(a, b, n, c, d, n, ctx=ctx)
        t_gpu = time.perf_counter() - t0

        overflow_note = "  (n*m > 2^32)" if total > 2**32 else ""
        speedup = f"{t_cpu / t_gpu:.2f}x" if run_cpu else "n/a"
        print(f"n=m={n:7d} (total={total:.3e}){overflow_note}: "
              f"CPU {t_cpu * 1000:10.2f} ms (V={v_cpu:.2f})  |  "
              f"GPU {t_gpu * 1000:10.2f} ms (V={v_gpu:.2f}, err={abs(v_gpu - analytic):.2f})  "
              f"speedup={speedup}")

    ctx.release()


if __name__ == "__main__":
    verify_correctness()

    # Moderate range: compare CPU and GPU directly.
    benchmark([500, 1000, 2000, 4000, 8000, 16000], run_cpu=True)

    # "Absolutely large" subdivisions: n*m exceeds the 32-bit index range
    # (2^32 ~= 4.29e9). CPU is skipped here (would need tens of GB of RAM /
    # very long run time for the equivalent NumPy meshgrid); GPU-only,
    # exercising the uint64_t-safe indexing path.
    benchmark([70000, 100000, 150000], run_cpu=False)
