from numpy.typing import NDArray
import numpy as np

def gauss_seidel(
    A: NDArray[np.float64],
    b: NDArray[np.float64],
    x: NDArray[np.float64],
    epsilon: float,
    M: int = 0
) -> NDArray[np.float64]:
    if not (A.shape[0] == A.shape[1] == len(b) == len(x)):
        raise ValueError("Incompatible matrix and vector dimensions")
    n = A.shape[0]

    while M != n:
        M = 0
        for i in range(n):
            S = 0
            for j in range(n):
                S += A[i, j] * x[j]
            X = (b[i] - S + A[i, i] * x[i]) / A[i, i]
            if abs((X - x[i])/X) < epsilon:
                M += 1
            x[i] = X
    return x