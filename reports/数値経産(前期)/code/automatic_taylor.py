"""
Automatic Taylor series via symbolic differentiation (sympy).

Usage:
    python code/automatic_taylor.py
"""

import sympy as sp
import numpy as np
import matplotlib.pyplot as plt
from math import factorial as math_factorial


def taylor_coefficients_exact(expr: sp.Expr, x: sp.Symbol, x0: float, n: int) -> list[float]:
    """Compute exact Taylor coefficients via symbolic differentiation."""
    coeffs = []
    for k in range(n + 1):
        deriv = sp.diff(expr, x, k)
        a_k = float(deriv.subs(x, x0)) / math_factorial(k)
        coeffs.append(a_k)
    return coeffs


def taylor_plot_exact(expr: sp.Expr, x_sym: sp.Symbol,
                      x0: float, n: int, r: tuple[float, float],
                      label: str = "Function") -> None:
    """Plot exact Taylor series via sympy differentiation."""
    min_a, min_b = r

    f = sp.lambdify(x_sym, expr, "numpy")

    fig, ax = plt.subplots(figsize=(10, 6))
    x_vals = np.linspace(min_a, min_b, 400)

    # True function
    y_true = f(x_vals)
    ax.plot(x_vals, y_true, label=label, color="black", linewidth=2, zorder=2)

    # Taylor polynomial
    coeffs = taylor_coefficients_exact(expr, x_sym, x0, n)
    y_approx = np.zeros_like(x_vals)
    for k in range(n + 1):
        y_approx += coeffs[k] * (x_vals - x0)**k
        if k == 0:
            continue
        ax.plot(x_vals, y_approx, linestyle="--", alpha=0.7,
                label=f"Taylor Polynomial (Order {k})")

    ax.set_xlim(min_a, min_b)
    ax.set_ylim(-4, 4)
    ax.set_xlabel("x", fontsize=14)
    ax.set_ylabel("y", fontsize=14)
    ax.grid(True, linestyle=":", alpha=0.6)
    ax.legend(loc="upper right", fontsize=11)
    plt.tight_layout()
    plt.show()


if __name__ == "__main__":
    x = sp.Symbol("x", real=True)

    # ── Task 1.8: e^x ──
    print("[Task 1.8] e^x, x0=0, n=10")
    taylor_plot_exact(
        expr=sp.exp(x), x_sym=x,
        x0=0.0, n=10, r=(-3, 3),
        label=r"$e^x$",
    )

    # ── Task 1.10: log(1+x) ──
    print("[Task 1.10] log(1+x), x0=0, n=10")
    taylor_plot_exact(
        expr=sp.log(1 + x), x_sym=x,
        x0=0.0, n=10, r=(-0.9, 3),
        label=r"$\log(1+x)$",
    )
