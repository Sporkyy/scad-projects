// ============================================================
// Turn-N-Tube shelf coupler — rigid lozenge collar
// Connects two adjacent shelf units at one tube height.
// Replaces zip ties: wraps both tube posts, with a fin on the
// underside that keys into the gap between the two units'
// edges (perpendicular to the tube-to-tube line) to resist
// rotation. Relies on gravity pressing down onto the shelf
// below, so the fin only needs to be on the bottom face per
// shelf level.
//
// The fin wedges the two units apart to whatever fin_width is,
// so the tube spacing you measure NOW is not the spacing the
// part has to fit. The hole spacing below is derived for the
// wedged-apart state — see fin_push.
//
// PRINT NOTES:
// - PETG, no supports needed (holes are round, drop wall is
//   solid down to a flat bottom).
// - Print with the collar axis vertical (as modeled) so the
//   holes print round and the tube slides through cleanly.
// - You'll want 2 of these per shelf level (one per photo's
//   "figure 8" pair), 8 total for the 5-tier unit in the photo
//   (top shelf has no tube, so no coupler there).
// ============================================================

// ===== MEASURE THESE ON YOUR ACTUAL SHELVES =====
// Everything here is an outside-the-solid measurement, so plain
// calipers reach all of it

tube_od = 30; // Outer diameter of the vertical tube post (mm) — outside jaws on the tube

// How you measured the tube spacing:
//   "gap"   - inside jaws opened across the clear space between the two tube
//             posts, at roughly this collar's height
//   "edges" - each tube's outer surface out to its own shelf's facing edge,
//             for when the calipers won't fit between the tubes; also handles
//             the case where the tubes aren't centered the same on each unit
spacing_mode = "gap";

// "gap" mode
tube_gap = 40; // Clear space between the facing outer surfaces of the two tubes (mm)

// "edges" mode
left_tube_to_edge = 20; // Left tube's outer surface to the left unit's right-hand edge (mm)
right_tube_to_edge = 20; // Right tube's outer surface to the right unit's left-hand edge (mm)

// Needed in BOTH modes — this is the slot the fin keys into
// Clear space between the two units' facing shelf edges, as they sit now (mm)
// Use 0 if the shelves are touching
shelf_edge_gap = 2;

drop_wall_height = 13; // How far the fin drops below the collar to key into the gap below (mm)

// NOTE: spacing may differ slightly shelf-to-shelf if the unit tapers —
// measure per shelf level and make one variant per size if needed

// ===== TUNE THESE =====
hole_clearance = 0.6; // Added to hole diameter for slip fit (mm) — increase if too tight
wall_meat = 7; // PETG thickness around each hole (mm)
collar_height = 10; // Height of the main collar at the shelf level (mm)

// The fin runs perpendicular to the tube-to-tube line (X axis), so it
// slots into the gap between the two shelf units' edges instead of
// running parallel to it
fin_width = 10; // Thickness of the fin along X — the left-right gap it wedges into (mm)
fin_depth = 40; // Length of the fin along Y, front-to-back (mm) — how deep it keys in

$fn = 100;

// ===== DERIVED =====
// Clear span between the tubes as they sit now
tube_gap_now = spacing_mode == "edges" ? left_tube_to_edge + shelf_edge_gap + right_tube_to_edge : tube_gap;

// The fin can only be as thin as the slot it makes, so anything wider than
// the current shelf-edge gap shoves the two units apart by the difference,
// and the tubes travel with them
fin_push = max(0, fin_width - shelf_edge_gap);

// Hole spacing for the wedged-apart state, not the as-measured one
center_distance = tube_od + tube_gap_now + fin_push;

hole_r = tube_od / 2 + hole_clearance / 2;
collar_r = hole_r + wall_meat;

// Where the shelf-edge slot ends up once wedged — dead centre in "gap" mode,
// biased toward whichever unit has the shorter tube-to-edge run in "edges" mode
edge_left_x = -center_distance / 2 + tube_od / 2 + left_tube_to_edge;
edge_right_x = center_distance / 2 - tube_od / 2 - right_tube_to_edge;
fin_x = spacing_mode == "edges" ? (edge_left_x + edge_right_x) / 2 : 0;

echo(str("center-to-center hole spacing = ", center_distance, " mm"));
echo(str("units get wedged apart by ", fin_push, " mm"));
echo(str("fin X offset from collar centre = ", fin_x, " mm"));

assert(fin_depth <= 2 * collar_r, "fin_depth exceeds the collar's width at the waist — the fin would overhang");
assert(abs(fin_x) + fin_width / 2 <= center_distance / 2 - hole_r, "fin overlaps a tube hole — reduce fin_width or check the edge measurements");

// 2D lozenge (stadium) shape: hull of two circles
module lozenge_2d(r, cdist) {
  hull() {
    translate([-cdist / 2, 0])
      circle(r = r);
    translate([cdist / 2, 0])
      circle(r = r);
  }
}

module coupler() {
  difference() {
    union() {
      // Main collar at shelf height
      linear_extrude(height = collar_height)
        lozenge_2d(collar_r, center_distance);

      // Anti-rotation fin, bottom face only, sitting under the waist of
      // the lozenge where the collar is a full 2*collar_r wide
      translate([fin_x, 0, -drop_wall_height])
        linear_extrude(height = drop_wall_height)
          square([fin_width, fin_depth], center = true);
    }

    // Through-holes for the two tube posts
    translate([-center_distance / 2, 0, -drop_wall_height - 1])
      cylinder(r = hole_r, h = collar_height + drop_wall_height + 2);
    translate([center_distance / 2, 0, -drop_wall_height - 1])
      cylinder(r = hole_r, h = collar_height + drop_wall_height + 2);
  }
}

coupler();
