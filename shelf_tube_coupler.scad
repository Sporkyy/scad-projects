// ============================================================
// Turn-N-Tube shelf coupler — rigid lozenge collar
// Connects two adjacent shelf units at one tube height.
// Replaces zip ties: a lozenge collar slips over both vertical
// tube posts and holds them at a fixed spacing, with an
// optional wall on the underside that fills the gap between
// the two units' facing shelf edges.
//
// The coupler DEFINES the spacing — it does not have to fit
// the units as they currently sit. Set the gap you want and
// the hole spacing follows from the tube and the tube-to-edge
// run on each unit. Nothing here depends on how far apart the
// units happen to be today.
//
// A deliberate gap is worth having: adjacent units rarely have
// their shelves at the same height, and the gap keeps that
// mismatch from reading as a misalignment.
//
// PRINT NOTES:
// - PETG, no supports needed (holes are round, the wall is
//   solid down to a flat bottom).
// - Print with the collar axis vertical (as modeled) so the
//   holes print round and the tube slides through cleanly.
// - Rests on the shelf below, so the wall only needs to be on
//   the bottom face. Two per shelf level (front and back post
//   pair), 8 total for a 5-tier unit — the top shelf has no
//   tube above it.
// ============================================================

// ===== MEASURE THESE ON YOUR ACTUAL SHELVES =====
// Both are outside-the-solid measurements, so plain calipers reach them

tube_od = 30; // Outer diameter of the vertical tube post (mm) — outside jaws on the tube

// Tube's outer surface out to the facing edge of its own shelf (mm).
// Measured on the side that faces the other unit
tube_to_edge = 20;

// Override these only if the two units differ — a shelf that overhangs
// further on one side, or a post that isn't set the same distance in
left_tube_to_edge = tube_to_edge;
right_tube_to_edge = tube_to_edge;

// ===== DECIDE THIS =====
// Gap you want between the two units' facing shelf edges (mm).
// This is a choice, not a measurement — the coupler holds the units here.
// Some gap hides shelf-height mismatch between the units
shelf_gap = 10;

// ===== WALL =====
// Solid wall hanging below the collar, filling the gap. Not structurally
// required — the hole spacing alone sets the gap, and two couplers per
// level already resist twist. It hides the gap and keeps stray items
// from dropping through
wall = false;
wall_height = 15; // How far the wall drops below the collar (mm)
// Thickness is shelf_gap exactly — it is the gap, made solid — and depth
// front-to-back is the collar's own depth, so both are derived below

// ===== TUNE THESE =====
hole_clearance = 0.6; // Added to hole diameter for slip fit (mm) — increase if too tight
wall_meat = 7; // PETG thickness around each hole (mm)
collar_height = 10; // Height of the main collar at the shelf level (mm)

$fn = 100;

// ===== DERIVED =====
// Tube centre to tube centre: half a tube, the run out to each shelf
// edge, and the gap between those edges
center_distance = tube_od + left_tube_to_edge + shelf_gap + right_tube_to_edge;

hole_r = tube_od / 2 + hole_clearance / 2;
collar_r = hole_r + wall_meat;

// Midpoint of the gap. Zero when both units measure the same, and
// offset toward the shorter run when they don't
wall_x = (left_tube_to_edge - right_tube_to_edge) / 2;

// The wall hangs under the waist of the lozenge, where the collar is a full
// 2*collar_r deep, so it runs flush with the collar's sides
wall_depth = 2 * collar_r;

echo(str("center-to-center hole spacing = ", center_distance, " mm"));
echo(str("overall length = ", center_distance + 2 * collar_r, " mm"));
echo(str("wall = ", shelf_gap, " x ", wall_depth, " mm at X offset ", wall_x, " mm"));

assert(!wall || shelf_gap > 0, "a wall needs a gap to fill — raise shelf_gap or set wall = false");
assert(abs(wall_x) + shelf_gap / 2 <= center_distance / 2 - hole_r, "wall overlaps a tube hole — check the tube-to-edge measurements");

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

      // Gap-filling wall, bottom face only, flush with the collar sides
      if (wall)
        translate([wall_x, 0, -wall_height])
          linear_extrude(height = wall_height)
            square([shelf_gap, wall_depth], center = true);
    }

    // Through-holes for the two tube posts
    translate([-center_distance / 2, 0, -wall_height - 1])
      cylinder(r = hole_r, h = collar_height + wall_height + 2);
    translate([center_distance / 2, 0, -wall_height - 1])
      cylinder(r = hole_r, h = collar_height + wall_height + 2);
  }
}

coupler();
