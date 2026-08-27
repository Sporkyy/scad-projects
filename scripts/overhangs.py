#!/usr/bin/env python3
"""Report the downward-facing surfaces of an exported STL.

Overhang angle is measured from vertical: a vertical wall is 0 deg, a flat
ceiling is 90 deg, and the usual unsupported limit is 45 deg. Facets lying on
the build plate are ignored, since the first layer is not an overhang.

Used as a library by build.py, which warns on what this finds without failing
the build.
"""

import math
import struct
import sys
from pathlib import Path

LIMIT = 45.0  # Degrees from vertical, the usual unsupported limit

PLATE = 1e-3  # Height below which a downward facet is just the first layer

# Degrees of grace for float32 vertex rounding. Normals are computed from the
# stored vertices, which land an exact 45 deg chamfer within microdegrees of
# the limit and an exact vertical wall within millidegrees of hanging, so both
# need slack — and a real design overhang is whole degrees past it
SLACK = 0.01


class MeshError(RuntimeError):
    pass


def read_facets(path):
    data = Path(path).read_bytes()
    if len(data) < 84:
        raise MeshError(f"{path}: too short to be a binary STL")
    count = struct.unpack("<I", data[80:84])[0]
    if len(data) < 84 + 50 * count:
        raise MeshError(f"{path}: not a binary STL, or truncated")
    for i in range(count):
        offset = 84 + 50 * i
        normal = struct.unpack("<3f", data[offset : offset + 12])
        vertices = [
            struct.unpack("<3f", data[offset + 12 + 12 * j : offset + 24 + 12 * j])
            for j in range(3)
        ]
        yield normal, vertices


def facet_nz(a, b, c):
    """Unit-normal z of a facet, from its vertices under the STL right-hand
    rule. The stored normal is deliberately not used: the spec lets it be
    zeroed and nothing keeps it unit length, and either would let a hanging
    face pass as vertical. Returns None for a degenerate facet, which has no
    area to hang
    """
    ux, uy, uz = (b[0] - a[0], b[1] - a[1], b[2] - a[2])
    vx, vy, vz = (c[0] - a[0], c[1] - a[1], c[2] - a[2])
    nx = uy * vz - uz * vy
    ny = uz * vx - ux * vz
    nz = ux * vy - uy * vx
    length = math.sqrt(nx * nx + ny * ny + nz * nz)
    if length == 0:
        return None
    return nz / length


def scan(path):
    """Group a mesh's overhanging facets by angle and height.

    Returns (total facets, groups), each group a (angle, z_min, z_max, count)
    tuple sorted shallowest first
    """
    groups = {}
    total = 0

    for _, vertices in read_facets(path):
        total += 1
        nz = facet_nz(*vertices)
        if nz is None:  # Degenerate, so nothing to hang
            continue
        if nz >= 0:  # Facing upward, never an overhang
            continue
        heights = [vertex[2] for vertex in vertices]
        if max(heights) <= PLATE:  # Sitting on the plate, not hanging over anything
            continue
        angle = math.degrees(math.asin(min(1.0, -nz)))
        if angle <= SLACK:  # Vertical, within mesh precision
            continue
        key = (round(angle, 1), round(min(heights), 2), round(max(heights), 2))
        count, worst_angle = groups.get(key, (0, angle))
        groups[key] = (count + 1, max(worst_angle, angle))

    return total, [
        (worst_angle, z_min, z_max, count)
        for (_, z_min, z_max), (count, worst_angle) in sorted(groups.items())
    ]


def past_limit(groups):
    return [group for group in groups if group[0] > LIMIT + SLACK]


def describe(group):
    angle, z_min, z_max, count = group
    return (
        f"{format_angle(angle)}° from vertical, z {z_min} – {z_max} mm, {count} facets"
    )


def format_angle(angle):
    return f"{angle:.2f}".rstrip("0").rstrip(".")


def report(path):
    total, groups = scan(path)
    print(f"{path}: {total} facets, {sum(g[3] for g in groups)} of them overhanging")

    if not groups:
        print("  nothing overhangs — prints without supports in this orientation")
        return 0

    print(f"  {'from vertical':>13}  {'z span (mm)':>16}  facets")
    for angle, z_min, z_max, count in groups:
        flag = "  <-- past the limit" if angle > LIMIT + SLACK else ""
        print(f"  {format_angle(angle):>12}°  {z_min:>7} – {z_max:<7}  {count}{flag}")

    worst = max(group[0] for group in groups)
    if worst > LIMIT + SLACK:
        print(
            f"\n  worst is {format_angle(worst)}°, past the {LIMIT}° limit — redesign the feature"
        )
        return 1
    print(f"\n  worst is {format_angle(worst)}°, within the {LIMIT}° limit")
    return 0


def main():
    if len(sys.argv) < 2:
        raise SystemExit("usage: overhangs.py <file.stl> [...]")
    try:
        return max(report(path) for path in sys.argv[1:])
    except (MeshError, OSError) as error:
        print(f"error: {error}", file=sys.stderr)
        return 2


if __name__ == "__main__":
    raise SystemExit(main())
