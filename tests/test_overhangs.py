# SPDX-License-Identifier: MIT
# SPDX-FileCopyrightText: 2026 Todd Sayre

import math
import sys
import unittest
from pathlib import Path
from unittest.mock import patch

# The scripts are plain files rather than a package, so put them on the path
sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "scripts"))

import overhangs  # noqa: E402


ZEROED_NORMAL = (0.0, 0.0, 0.0)  # The spec allows it, so scan must not read it


# A triangle whose face hangs the given angle past vertical, wound to the STL
# right-hand rule so its computed normal points down and out
def hanging_facet(angle):
    tilt = math.radians(angle)
    return (
        ZEROED_NORMAL,
        [(0, 0, 1), (1, 0, 1), (0, -math.sin(tilt), 1 - math.cos(tilt))],
    )


class ScanTests(unittest.TestCase):
    def test_flags_angle_that_rounds_down_to_limit(self):
        angle = 45.04
        facets = [hanging_facet(angle)]

        with patch.object(overhangs, "read_facets", return_value=iter(facets)):
            _, groups = overhangs.scan("synthetic.stl")

        self.assertAlmostEqual(groups[0][0], angle)
        self.assertEqual(overhangs.past_limit(groups), groups)

    def test_ignores_degenerate_facet_whatever_its_stored_normal_says(self):
        ceiling_normal = (0.0, 0.0, -1.0)
        collinear = [(0, 0, 1), (1, 0, 1), (2, 0, 1)]
        facets = [(ceiling_normal, collinear)]

        with patch.object(overhangs, "read_facets", return_value=iter(facets)):
            total, groups = overhangs.scan("synthetic.stl")

        self.assertEqual(total, 1)
        self.assertEqual(groups, [])


if __name__ == "__main__":
    unittest.main()
