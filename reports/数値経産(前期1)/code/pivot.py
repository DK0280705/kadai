from numpy.typing import NDArray
import numpy as np


def configure_pivot(
    C: NDArray[np.float64],
) -> NDArray[np.float64]:
    n = C.shape[0]
    for k in range(n):
        pivot_row = k
        max_val = abs(C[k, k])
        for i in range(k + 1, n):
            if abs(C[i, k]) > max_val:
                max_val = abs(C[i, k])
                pivot_row = i
        if pivot_row != k:
            C[[k, pivot_row]] = C[[pivot_row, k]]
    return C
