from typing import Callable
import numpy as np
from numpy.typing import NDArray


def rectangle_rule(f: Callable[[NDArray], NDArray], a: float, b: float, n: int) -> float:
    h = (b - a) / n
    x = a + np.arange(n) * h
    return float(np.sum(f(x)) * h)


def trapezoidal_rule(f: Callable[[NDArray], NDArray], a: float, b: float, n: int) -> float:
    h = (b - a) / n
    x = a + np.arange(n + 1) * h
    y = f(x)
    return float(np.sum(h / 2 * y[:-1] + y[1:]))


def simpson_rule(f: Callable[[NDArray], NDArray], a: float, b: float, n: int) -> float:
    """シンプソンの公式 (Simpson's 1/3 rule); n must be even."""
    if n % 2 != 0:
        raise ValueError("n must be even for Simpson's rule")
    h = (b - a) / n
    x = a + np.arange(n + 1) * h
    y = f(x)
    return float(np.sum(h / 3 * (y[0:n:2] + 4 * y[1:n:2] + y[2:n + 1:2])))
