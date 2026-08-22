import math
import unittest
from unittest.mock import patch

import overhangs


class ScanTests(unittest.TestCase):
    def test_flags_angle_that_rounds_down_to_limit(self):
        angle = 45.04
        normal = (0.0, 0.0, -math.sin(math.radians(angle)))
        facets = [(normal, [(0, 0, 1), (1, 0, 1), (0, 1, 2)])]

        with patch.object(overhangs, "read_facets", return_value=iter(facets)):
            _, groups = overhangs.scan("synthetic.stl")

        self.assertAlmostEqual(groups[0][0], angle)
        self.assertEqual(overhangs.past_limit(groups), groups)


if __name__ == "__main__":
    unittest.main()
