from typing import Callable


def newton_method(
    f: Callable[[float], float],
    df: Callable[[float], float],
    x0: float,
    epsilon: float = 1e-6,
    max_iter: int = 1000,
) -> tuple[float, list[float]]:
    x = x0
    history = [x]
    for _ in range(max_iter):
        x_new = x - f(x) / df(x)
        history.append(x_new)
        if abs((x_new - x) / x_new) < epsilon:
            x = x_new
            break
        x = x_new
    return x, history
