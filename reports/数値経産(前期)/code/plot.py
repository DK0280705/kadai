from numpy.typing import NDArray
import numpy as np
import matplotlib.pyplot as plt
from taylor_series import taylor_coefficients


def taylor_plot(title: str, f: callable, x0: float, n: int, r: tuple[float, float]):
    min_a, min_b = r

    fig, ax = plt.subplots(figsize=(10, 6))
    x = np.arange(min_a, min_b, 0.05)
    
    y_true = np.vectorize(f)(x)
    ax.plot(x, y_true, label="True Function", color="black", linewidth=2, zorder=2)

    coefficients = taylor_coefficients(f, x0, n)
    y_approx = np.zeros_like(x)
    for k in range(n + 1):
        y_approx += coefficients[k] * (x - x0)**k
        if k == 0: continue
        ax.plot(x, y_approx, linestyle="--", alpha=0.7, 
                label=f"Taylor Polynomial (Order {k})")
    plt.xlabel("x-axis", fontsize=14)
    plt.ylabel("y-axis", fontsize=14)            
    ax.set_ylim([-4, 4])
    ax.set_xlim([min_a, min_b])
    ax.grid(True, linestyle=":", alpha=0.6)
    ax.legend(loc="upper right")
    plt.savefig(f"images/{title.replace(' ', '_').replace('(', '').replace(')', '').replace(',', '')}.pdf")

def gauss_seidel_history(
    A: NDArray[np.float64],
    b: NDArray[np.float64],
    x: NDArray[np.float64],
    epsilon: float = 1e-6,
    max_iter: int = 10_000,
) -> tuple[NDArray[np.float64], list[NDArray[np.float64]]]:
    """
    Gauss-Seidel iterative solver with full iteration history.

    Returns
    -------
    x : ndarray          final solution
    history : list[ndarray]  list of x-vectors at each iteration
    """
    n = A.shape[0]
    history: list[NDArray[np.float64]] = [x.copy()]

    for iteration in range(max_iter):
        M = 0
        for i in range(n):
            S = np.dot(A[i, :], x)
            X = (b[i] - S + A[i, i] * x[i]) / A[i, i]
            if abs((X - x[i]) / X) < epsilon:
                M += 1
            x[i] = X
        history.append(x.copy())
        if M == n:
            break
    return x, history

def sor_history(
    A: NDArray[np.float64],
    b: NDArray[np.float64],
    x: NDArray[np.float64],
    omega: float,
    epsilon: float = 1e-6,
    max_iter: int = 10_000,
) -> tuple[NDArray[np.float64], list[NDArray[np.float64]]]:
    """
    SOR (Successive Over-Relaxation) solver with full iteration history.

    Returns
    -------
    x : ndarray          final solution
    history : list[ndarray]  list of x-vectors at each iteration
    """
    n = A.shape[0]
    history: list[NDArray[np.float64]] = [x.copy()]

    for iteration in range(max_iter):
        M = 0
        for i in range(n):
            S = np.dot(A[i, :], x)
            X = (b[i] - S + A[i, i] * x[i]) / A[i, i]
            X = x[i] + omega * (X - x[i])
            if abs((X - x[i]) / X) < epsilon:
                M += 1
            x[i] = X
        history.append(x.copy())
        if M == n:
            break
    return x, history


# ─────────────────────────────────────────────────────────────
# Plotting utility
# ─────────────────────────────────────────────────────────────

def plot_convergence(
    history: list[NDArray[np.float64]],
    title: str,
    variable_names: list[str] | None = None,
    locator=1,
) -> None:
    """
    Plot each variable's value across iterations.

    Parameters
    ----------
    history : list[ndarray]   x₀ … final (each entry = entire x-vector)
    title : str               plot title
    variable_names : list[str] labels for x₀, x₁, …
    """
    import matplotlib.ticker as ticker

    history_arr = np.array(history)  # shape (iterations, n)
    iterations = np.arange(len(history_arr))
    n_vars = history_arr.shape[1]

    if variable_names is None:
        variable_names = [f"$x_{{{i}}}$" for i in range(n_vars)]

    plt.figure(figsize=(10, 6))
    for i in range(n_vars):
        plt.plot(iterations, history_arr[:, i],
                 marker=".", markersize=4, linewidth=1.2,
                 label=variable_names[i])

    plt.xlabel("Iteration", fontsize=14)
    plt.ylabel("Value", fontsize=14)
    plt.legend(fontsize=12)
    plt.grid(True, alpha=0.3)
    ax = plt.gca()
    ax.xaxis.set_major_locator(ticker.MultipleLocator(locator))
    ax.set_xlim(left=0)
    ax.tick_params(labelsize=12)
    plt.tight_layout()
    plt.savefig(f"images/{title.replace(' ', '_').replace('(', '').replace(')', '').replace(',', '')}.pdf")


# ─────────────────────────────────────────────────────────────
# Exercise runners
# ─────────────────────────────────────────────────────────────

def task_1_1() -> None:
    """Task 1.1 — Gauss-Seidel, 2×2"""
    A = np.array([[3, -1], [2, 4]], dtype=np.float64)
    b = np.array([2, 1], dtype=np.float64)
    x0 = np.zeros(2)

    x, history = gauss_seidel_history(A, b, x0.copy())
    print(f"[Task 1.1] GS converged in {len(history) - 1} iterations → {x}")
    plot_convergence(history, "Task 1.1 — Gauss-Seidel (2×2)")


def task_1_2() -> None:
    """Task 1.2 — Gauss-Seidel & SOR, 2×2 (with pivot)"""
    # After pivot: rows swapped so diagonal is large
    A = np.array([[5, 3], [4, 6]], dtype=np.float64)
    b = np.array([1, 6], dtype=np.float64)

    # Gauss-Seidel
    x0 = np.zeros(2)
    x_gs, hist_gs = gauss_seidel_history(A, b, x0.copy())
    print(f"[Task 1.2] GS  converged in {len(hist_gs) - 1} iterations → {x_gs}")
    plot_convergence(hist_gs, "Task 1.2 — Gauss-Seidel (2×2, pivoted)")

    # SOR with ω = 1.4
    x0 = np.zeros(2)
    x_sor, hist_sor = sor_history(A, b, x0.copy(), omega=1.4)
    print(f"[Task 1.2] SOR converged in {len(hist_sor) - 1} iterations → {x_sor}")
    plot_convergence(hist_sor, "Task 1.2 — SOR omega=1.4 (2×2, pivoted)")


def task_1_3() -> None:
    """Task 1.3 — Gauss-Seidel & SOR, 3×3"""
    A = np.array([[2, 1, 1], [0, 2, 1], [1, 1, 1]], dtype=np.float64)
    b = np.array([1, 2, 2], dtype=np.float64)

    # Gauss-Seidel
    x0 = np.zeros(3)
    x_gs, hist_gs = gauss_seidel_history(A, b, x0.copy())
    print(f"[Task 1.3] GS  converged in {len(hist_gs) - 1} iterations → {x_gs}")
    plot_convergence(hist_gs, "Task 1.3 — Gauss-Seidel (3×3)")

    # SOR with ω = 1.4
    x0 = np.zeros(3)
    x_sor, hist_sor = sor_history(A, b, x0.copy(), omega=1.4)
    print(f"[Task 1.3] SOR converged in {len(hist_sor) - 1} iterations → {x_sor}")
    plot_convergence(hist_sor, "Task 1.3 — SOR omega=1.4 (3×3)", None, 2)


def task_1_8() -> None:
    """Task 1.8 — Maclaurin expansion of e^x"""
    print("[Task 1.8] Plotting Maclaurin expansion of e^x...")
    taylor_plot(
        "Task 1.8 — e^x Maclaurin",
        lambda x: np.exp(x),
        x0=0.0, n=10, r=(-3, 3),
    )


def task_1_10() -> None:
    """Task 1.10 — Maclaurin expansion of log(1+x)"""
    import math
    print("[Task 1.10] Plotting Maclaurin expansion of log(1+x)...")
    taylor_plot(
        "Task 1.10 — log(1+x) Maclaurin",
        lambda x: math.log(1 + x),
        x0=0.0, n=10, r=(-0.9, 3),
    )


def task_1_9() -> None:
    """Task 1.9 — Gauss-Seidel, 12×12 circuit network"""
    # Coefficient matrix from KCL at each node (R = 1 Ω, G = 1 S)
    A = np.array([
        [ 4, -1,  0, -1,  0,  0,  0,  0,  0,  0,  0,  0],
        [-1,  4, -1,  0, -1,  0,  0,  0,  0,  0,  0,  0],
        [ 0, -1,  4,  0,  0, -1,  0,  0,  0,  0,  0,  0],
        [-1,  0,  0,  4, -1,  0, -1,  0,  0,  0,  0,  0],
        [ 0, -1,  0, -1,  4, -1,  0, -1,  0,  0,  0,  0],
        [ 0,  0, -1,  0, -1,  4,  0,  0, -1,  0,  0,  0],
        [ 0,  0,  0, -1,  0,  0,  4, -1,  0, -1,  0,  0],
        [ 0,  0,  0,  0, -1,  0, -1,  4, -1,  0, -1,  0],
        [ 0,  0,  0,  0,  0, -1,  0, -1,  4,  0,  0, -1],
        [ 0,  0,  0,  0,  0,  0, -1,  0,  0,  4, -1,  0],
        [ 0,  0,  0,  0,  0,  0,  0, -1,  0, -1,  4, -1],
        [ 0,  0,  0,  0,  0,  0,  0,  0, -1,  0, -1,  4],
    ], dtype=np.float64)
    b = np.array([100, 100, 100, 0, 0, 0, 0, 0, 0, -100, -100, -100], dtype=np.float64)

    # Gauss-Seidel
    x0 = np.zeros(12)
    x_gs, hist_gs = gauss_seidel_history(A, b, x0.copy())
    print(f"[Task 1.9] GS converged in {len(hist_gs) - 1} iterations")
    print(f"  V = {np.array2string(x_gs, precision=6, suppress_small=True)}")
    print(f"  Residual ||Ax-b|| = {np.linalg.norm(A @ x_gs - b):.6e}")

    # Convergence plot
    variable_names = [f"$V_{{{i+1}}}$" for i in range(12)]
    plot_convergence(hist_gs, "Task 1.9 — Gauss-Seidel (12×12, circuit)", variable_names, locator=1)


# ─────────────────────────────────────────────────────────────
# Main
# ─────────────────────────────────────────────────────────────

if __name__ == "__main__":
    task_1_1()
    task_1_2()
    task_1_3()
    task_1_8()
    task_1_9()
    task_1_10()
