import numpy as np
import matplotlib.pyplot as plt

from taylor_series import taylor_coefficients


def plot(f: callable, x0: float, n: int, r: tuple[float, float]):
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
    plt.show()
