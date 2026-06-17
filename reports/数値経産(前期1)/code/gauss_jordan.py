from numpy.typing import NDArray
import numpy as np


def gauss_jordan(
    A: NDArray[np.float64],
    b: NDArray[np.float64],
) -> NDArray[np.float64]:
    if not (A.shape[0] == A.shape[1] == b.shape[0]):
        raise ValueError("Incompatible matrix dimensions")
    n = A.shape[0]
    x = np.zeros(n)

    C = np.column_stack((A, b))
    for k in range(n):
        c_dash = C[k, k]
        for j in range(k, n + 1):
            C[k, j] /= c_dash
        for i in range(n):
            if i == k:
                continue
            c_dash = C[i, k]
            for j in range(k, n + 1):
                C[i, j] -= c_dash * C[k, j]
    
    for i in range(n):
        x[i] = C[i, n]
    return x