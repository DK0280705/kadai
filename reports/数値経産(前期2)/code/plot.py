from numpy.typing import NDArray
import numpy as np
import matplotlib.pyplot as plt
import matplotlib.ticker as ticker

from newton import newton_method
from bisection import bisection_method
from integrals import rectangle_rule, trapezoidal_rule, simpson_rule
from double_integral import double_integral_rectangle
from circuits import i_cr, i_rlc

try:
    from double_integral_gpu import double_integral_rectangle_gpu, create_gpu_context
    _GPU_AVAILABLE = True
except ImportError:
    _GPU_AVAILABLE = False


# ─────────────────────────────────────────────────────────────
# Plotting utilities
# ─────────────────────────────────────────────────────────────

def _save(title: str) -> None:
    plt.tight_layout()
    plt.savefig(f"images/{title.replace(' ', '_').replace('(', '').replace(')', '').replace(',', '')}.pdf")
    plt.close()


def plot_root_convergence(history: list[float], target: float, title: str) -> None:
    """Plot x_k and |x_k - target| across iterations for a root-finding method."""
    x = np.array(history)
    k = np.arange(len(x))

    fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(12, 5))

    ax1.plot(k, x, marker=".", markersize=8, linewidth=1.2, color="SteelBlue")
    ax1.axhline(target, color="Coral", linestyle="--", label=f"analytic = {target:.6f}")
    ax1.set_xlabel("Iteration $k$", fontsize=13)
    ax1.set_ylabel("$x_k$", fontsize=13)
    ax1.xaxis.set_major_locator(ticker.MaxNLocator(integer=True))
    ax1.grid(True, alpha=0.3)
    ax1.legend(fontsize=11)

    err = np.abs(x - target)
    err[err == 0] = 1e-18  # avoid log(0)
    ax2.semilogy(k, err, marker=".", markersize=8, linewidth=1.2, color="SteelBlue")
    ax2.set_xlabel("Iteration $k$", fontsize=13)
    ax2.set_ylabel("$|x_k - \\mathrm{target}|$", fontsize=13)
    ax2.xaxis.set_major_locator(ticker.MaxNLocator(integer=True))
    ax2.grid(True, which="both", alpha=0.3)

    _save(title)


def plot_current_curve(
    t: NDArray, i: NDArray, marks: list[tuple[float, str]], title: str
) -> None:
    """Plot a transient current curve i(t) with vertical markers at given times."""
    plt.figure(figsize=(9, 5.5))
    plt.plot(t, i, color="Crimson", linewidth=2)
    for t_mark, label in marks:
        i_mark = np.interp(t_mark, t, i)
        plt.plot([t_mark, t_mark], [0, i_mark], linestyle=":", color="gray")
        plt.plot(t_mark, i_mark, marker="o", color="black", zorder=3)
        plt.annotate(label, (t_mark, i_mark), textcoords="offset points",
                     xytext=(6, 8), fontsize=12)
    plt.xlabel("$t$ [sec]", fontsize=13)
    plt.ylabel("$i(t)$ [A]", fontsize=13)
    plt.grid(True, alpha=0.3)
    _save(title)


def plot_integral_error(a: float, b: float, target: float, title: str) -> None:
    """Plot |S_n - target| vs n (log-log) for rectangle / trapezoidal / Simpson rules."""
    from integrals import rectangle_rule as rect, trapezoidal_rule as trap, simpson_rule as simp

    g = lambda x: 4 / (1 + x ** 2)
    ns = np.array([2 ** k for k in range(1, 12)])  # powers of two (even, needed for Simpson)

    err_rect = [abs(rect(g, a, b, int(n)) - target) for n in ns]
    err_trap = [abs(trap(g, a, b, int(n)) - target) for n in ns]
    err_simp = [abs(simp(g, a, b, int(n)) - target) for n in ns]

    plt.figure(figsize=(8, 5.5))
    plt.loglog(ns, err_rect, marker="o", label="Rectangle rule")
    plt.loglog(ns, err_trap, marker="s", label="Trapezoidal rule")
    plt.loglog(ns, np.clip(err_simp, 1e-16, None), marker="^", label="Simpson's rule")
    plt.xlabel("Number of subdivisions $n$", fontsize=13)
    plt.ylabel("$|S_n - \\pi|$", fontsize=13)
    plt.grid(True, which="both", alpha=0.3)
    plt.legend(fontsize=11)
    _save(title)


def plot_double_integral_convergence(target: float, title: str) -> None:
    """Plot V_{n,m} vs n(=m) approaching the analytical volume."""
    ns = [50, 100, 200, 500, 1000, 2000, 4000, 8000]
    f = lambda x, y: x ** 2 * y ** 2
    Vs = [double_integral_rectangle(f, 0, 10, n, 0, 20, n) for n in ns]

    plt.figure(figsize=(8, 5.5))
    plt.semilogx(ns, Vs, marker="o", color="SteelBlue", label="$V_{n,m}$ (rectangle rule)")
    plt.axhline(target, color="Coral", linestyle="--", label=f"analytic = {target:.2f}")
    plt.xlabel("Number of subdivisions $n = m$", fontsize=13)
    plt.ylabel("$V$", fontsize=13)
    plt.grid(True, which="both", alpha=0.3)
    plt.legend(fontsize=11)
    _save(title)


def plot_gpu_benchmark(ns: list[int], cpu_times: list[float], gpu_times: list[float], title: str) -> None:
    """Plot CPU vs GPU (compute shader) execution time, and speedup, vs grid size n=m."""
    ns = np.array(ns)
    cpu_times = np.array(cpu_times)
    gpu_times = np.array(gpu_times)
    speedup = cpu_times / gpu_times

    fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(12, 5))

    ax1.loglog(ns, cpu_times * 1000, marker="o", label="CPU (NumPy)", color="SteelBlue")
    ax1.loglog(ns, gpu_times * 1000, marker="s", label="GPU (compute shader)", color="Crimson")
    ax1.set_xlabel("Number of subdivisions $n = m$", fontsize=13)
    ax1.set_ylabel("Execution time [ms]", fontsize=13)
    ax1.grid(True, which="both", alpha=0.3)
    ax1.legend(fontsize=11)

    ax2.semilogx(ns, speedup, marker="o", color="SeaGreen")
    ax2.set_xlabel("Number of subdivisions $n = m$", fontsize=13)
    ax2.set_ylabel("Speed-up (CPU time / GPU time)", fontsize=13)
    ax2.grid(True, which="both", alpha=0.3)

    _save(title)


# ─────────────────────────────────────────────────────────────
# Exercise runners
# ─────────────────────────────────────────────────────────────

def task_2_1() -> None:
    """課題2.1 — Newton method for sqrt(7)"""
    f = lambda x: x ** 2 - 7
    df = lambda x: 2 * x
    x, history = newton_method(f, df, x0=3.0, epsilon=1e-6)
    print(f"[課題2.1] Newton converged in {len(history) - 1} iterations -> x = {x:.6f}")
    plot_root_convergence(history, np.sqrt(7), "Task 2.1 — Newton sqrt7")


def task_2_2() -> None:
    """課題2.2 — Bisection method for sqrt(7)"""
    f = lambda x: x ** 2 - 7
    x, history = bisection_method(f, x0=2.0, h0=1.0, epsilon=1e-6)
    print(f"[課題2.2] Bisection converged in {len(history) - 1} iterations -> x = {x:.6f}")
    plot_root_convergence(history, np.sqrt(7), "Task 2.2 — Bisection sqrt7")


def task_2_3() -> None:
    """課題2.3 — Rectangle / Trapezoidal / Simpson for S = int_0^1 4/(1+x^2) dx = pi"""
    g = lambda x: 4 / (1 + x ** 2)
    print("[課題2.3] S = integral of 4/(1+x^2) from 0 to 1 (analytic = pi)")
    for n in (10, 100, 1000):
        r = rectangle_rule(g, 0, 1, n)
        t = trapezoidal_rule(g, 0, 1, n)
        s = simpson_rule(g, 0, 1, n)
        print(f"  n={n:5d}: rect={r:.6f} (err={abs(r - np.pi):.2e}), "
              f"trap={t:.6f} (err={abs(t - np.pi):.2e}), "
              f"simpson={s:.6f} (err={abs(s - np.pi):.2e})")
    plot_integral_error(0, 1, np.pi, "Task 2.3 — Integral error comparison")


def task_2_4() -> None:
    """課題2.4 — CR circuit: Newton method for T such that i(T) = im/2"""
    E, R, C = 1.0, 100e3, 80e-6
    im = E / R
    target = im / 2
    f = lambda t: i_cr(t, E, R, C) - target
    df = lambda t: -(1 / (C * R)) * i_cr(t, E, R, C)
    T, history = newton_method(f, df, x0=1.0, epsilon=1e-6)
    print(f"[課題2.4] Newton converged in {len(history) - 1} iterations -> T = {T:.4f} sec")

    t = np.linspace(0, 4 * C * R, 400)
    i = i_cr(t, E, R, C)
    plot_current_curve(t, i, [(T, "$T$")], "Task 2.4 — CR circuit current")
    plot_root_convergence(history, T, "Task 2.4 — Newton CR circuit")


def task_2_5() -> None:
    """課題2.5 — RLC circuit: Bisection method for T1, T2 such that i(T) = im/2"""
    E, R, L = 1.0, 1095.0, 0.3
    t_peak = 2 * L / R
    im = 2 * E / (np.e * R)
    target = im / 2
    f = lambda t: i_rlc(t, E, R, L) - target

    T1, hist1 = bisection_method(f, x0=1e-8, h0=t_peak - 1e-8, epsilon=1e-9)
    T2, hist2 = bisection_method(f, x0=t_peak, h0=0.01 - t_peak, epsilon=1e-9)
    print(f"[課題2.5] T1 converged in {len(hist1) - 1} iterations -> T1 = {T1:.6e} sec")
    print(f"[課題2.5] T2 converged in {len(hist2) - 1} iterations -> T2 = {T2:.6e} sec")

    t = np.linspace(0, 0.006, 400)
    i = i_rlc(t, E, R, L)
    plot_current_curve(t, i, [(T1, "$T_1$"), (T2, "$T_2$")], "Task 2.5 — RLC circuit current")
    plot_root_convergence(hist1, T1, "Task 2.5 — Bisection RLC T1")
    plot_root_convergence(hist2, T2, "Task 2.5 — Bisection RLC T2")


def task_2_6() -> None:
    """応用課題2.6 — Double integral (rectangle rule) of x^2 y^2 over [0,10]x[0,20]"""
    a, b, c, d = 0, 10, 0, 20
    f = lambda x, y: x ** 2 * y ** 2
    analytic = (b ** 3 / 3) * (d ** 3 / 3)
    print(f"[応用課題2.6] Analytic V = {analytic:.4f}")
    for n in (100, 1000, 4000, 8000):
        V = double_integral_rectangle(f, a, b, n, c, d, n)
        print(f"  n=m={n:5d}: V = {V:.4f} (err = {abs(V - analytic):.4f})")
    plot_double_integral_convergence(analytic, "Task 2.6 — Double integral convergence")

    if not _GPU_AVAILABLE:
        print("[応用課題2.6] GPU (moderngl) not available -- skipping GPU benchmark")
        return

    import time
    print("[応用課題2.6] CPU (NumPy) vs GPU (compute shader) benchmark")
    ctx = create_gpu_context()
    double_integral_rectangle_gpu(a, b, 10, c, d, 10, ctx=ctx)  # warm-up (shader compile)

    ns = [500, 1000, 2000, 4000, 8000, 16000]
    cpu_times, gpu_times = [], []
    for n in ns:
        t0 = time.perf_counter()
        v_cpu = double_integral_rectangle(f, a, b, n, c, d, n)
        t_cpu = time.perf_counter() - t0

        t0 = time.perf_counter()
        v_gpu = double_integral_rectangle_gpu(a, b, n, c, d, n, ctx=ctx)
        t_gpu = time.perf_counter() - t0

        cpu_times.append(t_cpu)
        gpu_times.append(t_gpu)
        print(f"  n=m={n:6d}: CPU {t_cpu*1000:8.2f} ms (V={v_cpu:.2f})  |  "
              f"GPU {t_gpu*1000:8.2f} ms (V={v_gpu:.2f})  speedup={t_cpu/t_gpu:.2f}x")
    ctx.release()

    plot_gpu_benchmark(ns, cpu_times, gpu_times, "Task 2.6 — GPU vs CPU benchmark")


# ─────────────────────────────────────────────────────────────
# Main
# ─────────────────────────────────────────────────────────────

if __name__ == "__main__":
    task_2_1()
    task_2_2()
    task_2_3()
    task_2_4()
    task_2_5()
    task_2_6()
