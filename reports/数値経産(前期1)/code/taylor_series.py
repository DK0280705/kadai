from numpy.typing import NDArray
import numpy as np


def taylor_coefficients(
    f: callable,
    x0: float,
    n: int,
    h: float = 0.05
) -> NDArray[np.float64]:
    c = np.arange(n + 1).astype(np.float64)
    for i in range(n + 1):
        c[i] = f(x0 + i * h)
    for j in range(1, n + 1):
        for i in range(n, j - 1, -1):
            c[i] = (c[i] - c[i - 1]) / (j * h)
    return c
