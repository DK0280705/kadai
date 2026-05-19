"""
convergence_plot.py
===================
Track and plot the convergence of x₀, x₁, …, xₙ over iteration count
for the iterative methods: Gauss-Seidel and SOR.

Exercises covered:
    Task 1.1 — Gauss-Seidel, 2×2
    Task 1.2 — Gauss-Seidel & SOR (with pivot), 2×2
    Task 1.3 — Gauss-Seidel & SOR, 3×3

Usage:
    python code/convergence_plot.py
"""

from numpy.typing import NDArray
import numpy as np
import matplotlib.pyplot as plt

# ─────────────────────────────────────────────────────────────
# History-tracking versions of the iterative solvers
# ─────────────────────────────────────────────────────────────

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

    plt.figure(figsize=(8, 5))
    for i in range(n_vars):
        plt.plot(iterations, history_arr[:, i],
                 marker=".", markersize=3, linewidth=0.8,
                 label=variable_names[i])

    plt.xlabel("Iteration")
    plt.ylabel("Value")
    plt.title(title)
    plt.legend()
    plt.grid(True, alpha=0.3)
    ax = plt.gca()
    ax.xaxis.set_major_locator(ticker.MultipleLocator(1))
    ax.set_xlim(left=0)
    plt.tight_layout()
    plt.savefig(f"images/{title.replace(' ', '_').replace('(', '').replace(')', '').replace(',', '')}.pdf")
    plt.show()


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
    plot_convergence(hist_sor, "Task 1.3 — SOR omega=1.4 (3×3)")


# ─────────────────────────────────────────────────────────────
# Main
# ─────────────────────────────────────────────────────────────

if __name__ == "__main__":
    task_1_1()
    task_1_2()
    task_1_3()
