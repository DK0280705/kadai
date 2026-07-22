from typing import Callable


def double_integral_rectangle(
    f: Callable[[float, float], float],
    a: float, b: float, n: int,
    c: float, d: float, m: int,
) -> float:
    hx = (b - a) / n
    hy = (d - c) / m
    total = sum(
        sum(
            f(a + i * hx, c + j * hy)
            for j in range(m)
        )
        for i in range(n)
    )
    return total * hx * hy

