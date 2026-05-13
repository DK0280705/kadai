from numpy.typing import NDArray
import numpy as np

def inverse_matrix(
    A: NDArray[np.float64],
    b: NDArray[np.float64],
) -> NDArray[np.float64]:
    if not (A.shape[0] == A.shape[1] == b.shape[0]):
        raise ValueError("Incompatible matrix dimensions")
    n = A.shape[0]
    x = np.zeros(n)

    # Basically the same as gauss_jordan, but we use identity matrix instead of b
    C = np.column_stack((A, np.identity(n)))
    for k in range(n):
        pivot_row = k
        max_val = abs(C[k, k])
        for i in range(k + 1, n):
            if abs(C[i, k]) > max_val:
                max_val = abs(C[i, k])
                pivot_row = i
        if pivot_row != k:
            C[[k, pivot_row]] = C[[pivot_row, k]]

        c_dash = C[k, k]
        for j in range(k, 2 * n):
            C[k, j] /= c_dash
        for i in range(n):
            if i == k:
                continue
            c_dash = C[i, k]
            for j in range(k, 2 * n):
                C[i, j] -= c_dash * C[k, j]
    
    for i in range(n):
        x[i] = 0
        for j in range(n):
            x[i] += C[i, n + j] * b[j]
    return x