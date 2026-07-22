import numpy as np
from numpy.typing import NDArray


def i_cr(t: NDArray, E: float, R: float, C: float) -> NDArray:
    """CR直列回路の電流 i(t) = (E/R) e^{-t/(CR)}  [A]"""
    return (E / R) * np.exp(-t / (C * R))


def i_rlc(t: NDArray, E: float, R: float, L: float) -> NDArray:
    """RLC直列回路の電流 (R^2 = 4L/C のとき) i(t) = (E/L) t e^{-Rt/(2L)}  [A]"""
    return (E / L) * t * np.exp(-R * t / (2 * L))
