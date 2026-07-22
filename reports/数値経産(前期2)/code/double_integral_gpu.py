"""GPU (compute shader) accelerated double integral for 応用課題2.6.

This module implements the same rectangle-rule double integral as
``double_integral.py``, but evaluates the grid and reduces the sum entirely
on the GPU via a GLSL compute shader (using moderngl). This is an
optimization specific to the integrand of Task 2.6, f(x, y) = x^2 y^2,
used to demonstrate the speed-up of massively-parallel evaluation over the
plain NumPy/CPU implementation for large grid sizes (n, m).

All arithmetic (grid-point evaluation, workgroup shared-memory reduction,
and the final CPU-side sum) is carried out in double precision (float64 /
GLSL ``double``), matching the precision of the NumPy/CPU implementation.
The grid-point index and total point count (n*m) are computed with 64-bit
integers (GLSL ``uint64_t``, via GL_ARB_gpu_shader_int64) so that
subdivisions with n*m exceeding the 32-bit range (~4.29e9 points) do not
silently overflow/wrap -- this lets n, m be pushed arbitrarily large,
limited only by available GPU memory (SSBO size) and time.
"""

import numpy as np
import moderngl

_LOCAL_SIZE = 256

_COMPUTE_SHADER_SRC = """
#version 430
#extension GL_ARB_gpu_shader_int64 : require
layout(local_size_x = {local_size}) in;

layout(std430, binding = 0) buffer PartialSums {{
    double partial_sums[];
}};

uniform double a, b, c, d;
uniform uint n, m;

shared double sdata[{local_size}];

void main() {{
    // 64-bit global index: avoids uint32 overflow of gl_GlobalInvocationID
    // when the total grid size n*m exceeds ~4.29e9 (2^32).
    uint64_t idx   = uint64_t(gl_WorkGroupID.x) * uint64_t(gl_WorkGroupSize.x)
                    + uint64_t(gl_LocalInvocationID.x);
    uint64_t total = uint64_t(n) * uint64_t(m);

    double hx = (b - a) / double(n);
    double hy = (d - c) / double(m);

    double val = 0.0LF;
    if (idx < total) {{
        uint64_t i = idx / uint64_t(m);
        uint64_t j = idx % uint64_t(m);
        double x = a + double(i) * hx;
        double y = c + double(j) * hy;
        val = x * x * y * y * hx * hy;   // f(x, y) = x^2 y^2 (Task 2.6 integrand)
    }}

    uint lid = gl_LocalInvocationID.x;
    sdata[lid] = val;
    barrier();

    // Parallel reduction within the workgroup (shared memory, double precision)
    for (uint stride = gl_WorkGroupSize.x / 2u; stride > 0u; stride >>= 1u) {{
        if (lid < stride) {{
            sdata[lid] += sdata[lid + stride];
        }}
        barrier();
    }}

    if (lid == 0u) {{
        // gl_WorkGroupID.x stays native uint32 here: array indices must be
        // 32-bit, and the number of *workgroups* (unlike n*m) never
        // approaches the uint32 range for any practically dispatchable job.
        partial_sums[gl_WorkGroupID.x] = sdata[0];
    }}
}}
"""


def double_integral_rectangle_gpu(
    a: float, b: float, n: int,
    c: float, d: float, m: int,
    local_size: int = _LOCAL_SIZE,
    ctx: "moderngl.Context | None" = None,
) -> float:
    """2重積分 (区分求積法) をGPUコンピュートシェーダー (倍精度) で計算する。

    f(x, y) = x^2 y^2 の評価と総和 (ワークグループ内リダクション) を
    倍精度浮動小数点 (double) でGPU上で行い、ワークグループ数だけの
    部分和をCPUに転送して最終合計 (float64) する。
    グリッド点数 n*m が32bit整数の範囲 (約42.9億) を超えても、内部の
    インデックス計算を64bit整数 (uint64_t) で行うためオーバーフローしない。

    Parameters
    ----------
    ctx : 呼び出し側で作成したmodernglコンテキストを再利用する場合に渡す。
          省略時はこの呼び出し内でスタンドアロンコンテキストを作成・破棄する
          (毎回のGPUドライバ初期化コストが加わる点に注意)。
    """
    owns_ctx = ctx is None
    if ctx is None:
        ctx = moderngl.create_context(standalone=True)
    try:
        total = n * m
        num_groups = (total + local_size - 1) // local_size

        compute = ctx.compute_shader(_COMPUTE_SHADER_SRC.format(local_size=local_size))
        compute["a"].value = float(a)
        compute["b"].value = float(b)
        compute["c"].value = float(c)
        compute["d"].value = float(d)
        compute["n"].value = int(n)
        compute["m"].value = int(m)

        buf = ctx.buffer(reserve=num_groups * 8)  # 8 bytes per double
        buf.bind_to_storage_buffer(0)

        compute.run(group_x=num_groups)

        partial_sums = np.frombuffer(buf.read(), dtype=np.float64)
        return float(np.sum(partial_sums, dtype=np.float64))
    finally:
        if owns_ctx:
            ctx.release()


def create_gpu_context() -> "moderngl.Context":
    """ベンチマークなどでコンテキスト作成コストを償却するためのヘルパー。"""
    return moderngl.create_context(standalone=True)
