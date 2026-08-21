// ============================================================
// Turn-N-Tube shelf brace — diagonal triangulating link
// The third link that makes two adjacent shelf units rigid.
//
// Two couplers at one level do not hold the units still. Each
// is pinned at both ends by a round tube in a round hole, so
// the pair forms a four-bar linkage: one degree of freedom, no
// matter how stiff the couplers are or how far apart they sit.
// The units stay parallel and shear sideways. That is
// kinematic, not a stiffness problem, which is why the
// coupler's old gap-filling wall never fixed it — friction was
// all it had.
//
// Two rigid bodies have three degrees of freedom in plan and
// each link removes one, so three links lock them together.
// This brace is the third. It runs diagonally from one unit's
// FRONT post to the other unit's BACK post, so it is not
// parallel to the couplers and takes away the freedom they
// leave behind.
//
// Three links is the entire requirement. One brace anywhere in
// the stack makes the pair rigid; couplers at the other levels
// only add stiffness.
//
// PRINT NOTES:
// - Modelled as a straight bar. The diagonal is where it goes,
//   not what it is.
// - Long. Turned 45 degrees on the bed it needs far less room
//   than it does square on — check the echoed bed placement.
// - PETG, no supports, flat on the bed. Flat runs the
//   perimeters along the load path; on edge would load the
//   part across its layers.
// - It shares posts with the couplers at whichever level it
//   goes on, resting on one at each end, so it sits level a
//   coupler's height above the shelf.
// - One per pair of units, not one per level.
// ============================================================

// ===== MEASURE THESE ON YOUR ACTUAL SHELVES =====
// All of them are outside-the-solid measurements, so plain calipers reach them

tube_od = 30; // Outer diameter of the vertical tube post (mm) — outside jaws on the tube

// Tube's outer surface out to the facing edge of its own shelf (mm), measured
// on the side that faces the other unit. Same measurement the coupler uses, and
// it has to match — the two parts share the across-the-gap hole spacing
tube_to_edge = 20;

// Override these only if the two units differ
left_tube_to_edge = tube_to_edge;
right_tube_to_edge = tube_to_edge;

// Front-to-back span across one unit's two posts, outer face to outer face
// (mm). Lay a tape along the side of the unit at any shelf level — both faces
// are exposed. Measured at 200.3 on these shelves and recorded as 200 even.
// Re-measure it for other units rather than deriving it from the board depth:
// this number sets the brace length almost one-for-one
post_span = 200;

// Ground truth, if you would rather not trust the two spans agreeing. Measure
// diagonally across the assembled pair, outer face of one unit's front tube to
// outer face of the other unit's back tube, and put it here. Leave it undef to
// derive the diagonal instead
brace_span = undef;

// ===== DECIDE THIS =====
// Gap between the two units' facing shelf edges (mm). Must be the same value
// the couplers were printed with — they set the gap, and the brace has to
// agree with where they put the posts
shelf_gap = 5;

// ===== TUNE THESE =====
// Deliberately looser than the coupler's fit. The brace is a length-critical
// part with no slot to take up error, so this buys tolerance for a tape
// measurement. It costs about half of it in residual sway, which is nothing
// against the free degree of freedom it removes
hole_clearance = 2;

wall_meat = 5; // PETG thickness around each hole (mm)
brace_height = 5; // Thickness of the bar (mm) — match the coupler so it stacks flat
bed_size = 256; // Print bed, short side (mm)
bed_margin = 6; // Kept clear at the bed edges for brim and skirt (mm)

$fn = 100;

// ===== DERIVED =====
// Across the gap: half a tube, the run out to each shelf edge, and the gap.
// Identical to the coupler's own hole spacing, by construction
across_center_distance = tube_od + left_tube_to_edge + shelf_gap + right_tube_to_edge;

// Front to back along one unit, centre to centre
depth_center_distance = post_span - tube_od;

// The diagonal itself: front post of one unit to back post of the other
derived_brace_distance = sqrt(across_center_distance * across_center_distance + depth_center_distance * depth_center_distance);
brace_center_distance = is_undef(brace_span) ? derived_brace_distance : brace_span - tube_od;

hole_r = tube_od / 2 + hole_clearance / 2;
collar_r = hole_r + wall_meat;

overall_length = brace_center_distance + 2 * collar_r;
overall_width = 2 * collar_r;

// Smallest square of bed the bar needs. Turning it 45 degrees only pays while
// the part stays narrow: past a width of bed_size * (sqrt(2) - 1) the growing
// bounding box costs more than the diagonal gains, and square on wins
turned_square = (overall_length + overall_width) / sqrt(2);
bed_square = min(overall_length, turned_square);
bed_angle = turned_square < overall_length ? 45 : 0;

echo(str("across-the-gap hole spacing = ", across_center_distance, " mm"));
echo(str("front-to-back hole spacing = ", depth_center_distance, " mm"));
echo(str("brace hole spacing = ", brace_center_distance, " mm"));
echo(str("overall size = ", overall_length, " x ", overall_width, " mm"));
echo(str("bed placement = ", bed_angle, " deg, needs a ", bed_square, " mm square"));

assert(depth_center_distance > 0, "post_span is smaller than a tube — that span is measured outer face to outer face across both posts, not between them");
assert(brace_center_distance > 2 * hole_r, "the two holes overlap — check post_span and shelf_gap");
assert(bed_square <= bed_size - bed_margin, "brace does not fit the print bed — see the echoed bed placement, and split it into two bolted halves if the units really are this deep");

// 2D lozenge (stadium) shape: hull of two circles. Duplicated from
// shelf_tube_coupler.scad rather than shared, because every source here is
// meant to stand on its own
module lozenge_2d(r, cdist) {
  hull() {
    translate([-cdist / 2, 0])
      circle(r = r);
    translate([cdist / 2, 0])
      circle(r = r);
  }
}

module brace() {
  difference() {
    linear_extrude(height = brace_height)
      lozenge_2d(collar_r, brace_center_distance);

    // Through-holes for the two tube posts
    translate([-brace_center_distance / 2, 0, -1])
      cylinder(r = hole_r, h = brace_height + 2);
    translate([brace_center_distance / 2, 0, -1])
      cylinder(r = hole_r, h = brace_height + 2);
  }
}

brace();
