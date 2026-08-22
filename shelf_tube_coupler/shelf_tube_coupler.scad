// ============================================================
// Turn-N-Tube shelf coupler — rigid lozenge collar
// Connects two adjacent shelf units at one tube height.
// Replaces zip ties: a lozenge collar slips over both vertical
// tube posts and holds them at a fixed spacing.
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
// There is deliberately no gap-filling wall. An earlier version
// hung one below the collar to stiffen the pair and it did
// nothing: couplers are pinned at both ends by a round tube in
// a round hole, and every one of them runs the same direction,
// so the pair keeps a degree of freedom to shear sideways
// however many are fitted. A wall can only fight that with
// friction, and it lost. Printing it back would buy nothing —
// shelf_tube_brace.scad is the diagonal link that removes the
// freedom itself.
//
// PRINT NOTES:
// - PETG, no supports needed — a flat plate with round holes.
// - Print with the collar axis vertical (as modeled) so the
//   holes print round and the tube slides through cleanly.
// - Rests on the shelf below. Two per shelf level (front and
//   back post pair), 8 total for a 5-tier unit — the top shelf
//   has no tube above it.
// - These hold the spacing, not the squareness. Add one
//   shelf_tube_brace per pair of units.
// ============================================================

// ===== MEASURE THESE ON YOUR ACTUAL SHELVES =====
// Both are outside-the-solid measurements, so plain calipers reach them. Each
// one names the caliper it needs, by the size printed on the tool: a 6 in
// caliper stops at 150 mm, an 8 in at 200 mm, a 12 in at 300 mm

tube_od = 30; // Outer diameter of the vertical tube post (mm) — outside jaws on the tube, 6 in caliper

// Tube's outer surface out to the facing edge of its own shelf (mm), 6 in
// caliper. Measured on the side that faces the other unit. Eyeball it if the
// calipers won't reach — error here just shifts the gap you end up with by the
// same amount, it never stops the part going onto the tubes
tube_to_edge = 20;

// Override these only if the two units differ — a shelf that overhangs
// further on one side, or a post that isn't set the same distance in
left_tube_to_edge = tube_to_edge;
right_tube_to_edge = tube_to_edge;

// ===== DECIDE THIS =====
// Gap you want between the two units' facing shelf edges (mm).
// This is a choice, not a measurement — the coupler holds the units here.
// Some gap hides shelf-height mismatch between the units
shelf_gap = 5;

// ===== TUNE THESE =====
hole_clearance = 0.6; // Added to hole diameter for slip fit (mm) — increase if too tight
wall_meat = 5; // PETG thickness around each hole (mm)
collar_height = 5; // Height of the main collar at the shelf level (mm)

$fn = 100;

// ===== DERIVED =====
// Tube centre to tube centre: half a tube, the run out to each shelf
// edge, and the gap between those edges
center_distance = tube_od + left_tube_to_edge + shelf_gap + right_tube_to_edge;

hole_r = tube_od / 2 + hole_clearance / 2;
collar_r = hole_r + wall_meat;

// Narrowest material across the waist, between the two holes. The collar is
// only as strong as this, and it is what a very small shelf_gap eats into
waist = center_distance - 2 * hole_r;

echo(str("center-to-center hole spacing = ", center_distance, " mm"));
echo(str("overall length = ", center_distance + 2 * collar_r, " mm"));
echo(str("waist between the holes = ", waist, " mm"));

assert(waist > 0, "the two holes have run together — shelf_gap plus the tube-to-edge runs has to beat hole_clearance");

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
    linear_extrude(height = collar_height)
      lozenge_2d(collar_r, center_distance);

    // Through-holes for the two tube posts
    translate([-center_distance / 2, 0, -1])
      cylinder(r = hole_r, h = collar_height + 2);
    translate([center_distance / 2, 0, -1])
      cylinder(r = hole_r, h = collar_height + 2);
  }
}

coupler();
