from typing import Callable


def bisection_method(
    f: Callable[[float], float],
    x0: float,
    h0: float,
    epsilon: float = 1e-6,
    max_iter: int = 1000,
) -> tuple[float, list[float]]:
    x = x0
    h = h0
    history = [x]
    k = 0
    while h > epsilon and k < max_iter:
        k += 1
        h = h / 2
        if f(x) * f(x + h) < 0:
            pass
        else:
            x = x + h
        history.append(x)
    return x, history
