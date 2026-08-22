#!/usr/bin/env python3
"""Report the downward-facing surfaces of an exported STL.

Overhang angle is measured from vertical: a vertical wall is 0 deg, a flat
ceiling is 90 deg, and the usual unsupported limit is 45 deg. Facets lying on
the build plate are ignored, since the first layer is not an overhang.
"""

import math
import struct
import sys

LIMIT = 45.0  # Degrees from vertical, the usual unsupported limit
PLATE = 1e-3  # Height below which a downward facet is just the first layer


def facets(path):
    data = open(path, "rb").read()
    if len(data) < 84:
        raise SystemExit(f"{path}: too short to be a binary STL")
    count = struct.unpack("<I", data[80:84])[0]
    if len(data) < 84 + 50 * count:
        raise SystemExit(f"{path}: not a binary STL, or truncated")
    for i in range(count):
        o = 84 + 50 * i
        normal = struct.unpack("<3f", data[o:o + 12])
        verts = [struct.unpack("<3f", data[o + 12 + 12 * j:o + 24 + 12 * j]) for j in range(3)]
        yield normal, verts


def report(path):
    groups = {}
    total = 0
    for (_, _, nz), verts in facets(path):
        total += 1
        if nz >= -1e-6:  # Upward or vertical, never an overhang
            continue
        zs = [v[2] for v in verts]
        if max(zs) <= PLATE:  # Sitting on the plate, not hanging over anything
            continue
        angle = math.degrees(math.asin(min(1.0, abs(nz))))
        key = (round(angle, 1), round(min(zs), 2), round(max(zs), 2))
        groups[key] = groups.get(key, 0) + 1

    print(f"{path}: {total} facets, {sum(groups.values())} of them overhanging")
    if not groups:
        print("  nothing overhangs — prints without supports in this orientation")
        return 0

    print(f"  {'from vertical':>13}  {'z span (mm)':>16}  facets")
    worst = 0.0
    for (angle, z0, z1), n in sorted(groups.items()):
        flag = "  <-- past the limit" if angle > LIMIT + 1e-6 else ""
        print(f"  {angle:>12}°  {z0:>7} – {z1:<7}  {n}{flag}")
        worst = max(worst, angle)

    if worst > LIMIT + 1e-6:
        print(f"\n  worst is {worst}°, past the {LIMIT}° limit — redesign the feature")
        return 1
    print(f"\n  worst is {worst}°, within the {LIMIT}° limit")
    return 0


if __name__ == "__main__":
    if len(sys.argv) < 2:
        raise SystemExit("usage: overhangs.py <file.stl> [...]")
    sys.exit(max(report(p) for p in sys.argv[1:]))
