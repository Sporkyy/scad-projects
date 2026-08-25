// ============================================================
// Pencil rest — a block with a cradle down its top, to park a
// pencil on the desk instead of letting it roll off
//
// A rectangular block with every edge chamfered and one
// cylindrical trough running the length of its top face. The
// pencil lies in the trough. Length is how much of the pencil
// is carried, width is how much desk the block stands on, and
// both are free choices.
//
// THE CRADLE IS NOT A CHOICE. Its radius is the pencil plus a
// clearance, it is cut to exactly half a cylinder, and the
// block is then made as tall as that cut plus the floor left
// under it. Height falls out of the cradle rather than the
// cradle being fitted into a height, which is what makes it
// impossible for the trough to reach the bottom: floor_meat is
// what is left under the deepest point, always, whatever
// pencil the block is cut for and however wide or long it is
// made.
//
// Cutting exactly half the cylinder is the other thing that is
// fixed by construction. The depth of the cut and the radius
// of the cut are one expression, so the trough walls arrive at
// the top face vertical. A deeper cut would undercut the
// pencil — it could not be dropped in, only threaded in from
// the end, and the roof of the undercut would be an overhang.
// Half is the deepest a cradle can be and still open upward,
// and it also leaves the pencil standing half proud, which is
// what makes it easy to pick up.
//
// The trough runs out through both ends. A blind dish would
// need end walls, and end walls in a scoop this shallow are
// the one place a support would be wanted.
//
// A round punch through the middle is what makes the pencil
// possible to pick up. It takes the rim away on both sides at
// once, so a finger and thumb close on the pencil's whole
// diameter instead of pinching at whatever stands proud of the
// top face. Neither of its limits is a number to get right:
//
// - It cannot reach the sides. Its diameter is the width less
//   the flat, the ease and the chamfer either side, so the
//   material outside it is what punch_wall says it is and no
//   value of anything can eat it.
// - It cannot go deeper than the trough. Its floor is written
//   as the trough's own deepest point, not as a depth of its
//   own, so the two are one plane and the punch can never be
//   the feature that breaks the bottom.
//
// That floor also lands exactly level with the underside of
// the pencil, which is not a coincidence to be tuned: a round
// pencil beds at the bottom of a round trough, so its lowest
// point and the trough's are the same point whatever the
// clearance. A finger does not get under the pencil, and it
// does not need to.
//
// PRINT NOTES:
// - PLA or PETG, no supports needed. Print as modeled, base
//   down.
// - Nothing bridges. The cradle opens upward, so its whole
//   surface faces up, and so does the punch: flat floor,
//   vertical wall, and an ease at the rim that is a 45 deg
//   cone opening up. The only downward faces in the part are
//   the chamfers along the base, at 45 deg.
// - Every chamfer here has its run and its rise in the same
//   expression, so no value of any knob can turn one into an
//   overhang.
// - Print it solid, or near it. It is a small block and the
//   only thing it has to do is stay put, which is a question
//   of mass and of the friction of the bottom face.
// - The bottom face is the one that shows least and the top
//   face is the one a pencil rolls on, so this way up also
//   puts the plate's finish where it does no harm.
// ============================================================

// ===== MEASURE THIS ON YOUR ACTUAL PENCIL =====
// An outside-the-solid measurement, so plain calipers reach it. It names the
// caliper it needs by the size printed on the tool: a 6 in caliper stops at
// 150 mm, an 8 in at 200 mm, a 12 in at 300 mm

// Outer diameter of the pencil (mm) — outside jaws on the barrel, 6 in
// caliper. A hexagonal pencil is not round: take it across the corners rather
// than across the flats, and use the largest reading, since the corners are
// what the cradle has to clear. Measure the barrel, not the ferrule
pencil_d = 10;

// ===== DECIDE THESE =====
// The footprint. Neither one can reach the cradle, and neither one can change
// its shape

// Length of the block (mm), along the pencil. How much of the pencil is
// carried; a long one is a tray for several, a short one is a bridge under one
block_l = 100;

// Width of the block (mm), across the pencil. How much desk it stands on, and
// so how hard it is to knock over. It has to be wider than the cradle plus a
// rim either side, which is asserted below
block_w = 30;

// ===== TUNE THESE =====
pencil_clearance = 0.5; // Added to the cradle radius (mm) — the pencil drops in and lifts out rather than being pressed into a socket
floor_meat = 3; // Material left under the deepest point of the cradle (mm). This is the number that keeps the trough off the bottom, and the block grows taller to hold it
chamfer = 1; // Break on every edge of the block (mm)
cradle_ease = 0.6; // Break along both rims of the cradle (mm) — the edge a pencil is rolled over on its way in
punch_wall = 2; // Flat left on the top face between the punch and the outer chamfer (mm). This is the knob that sets how big the punch comes out, and it is the material that keeps it off the sides
punch_ease = 0.6; // Break around the rim of the punch (mm) — the edge a fingertip drags over

$fn = 120;

// ===== DERIVED =====

// The cradle. Radius from the pencil, depth from the radius: one expression
// for both, so the cut is half a cylinder whatever the pencil measures and the
// walls always reach the top face vertical
cradle_r = pencil_d / 2 + pencil_clearance;
cradle_depth = cradle_r;

// Height of the block. It is the cut plus the floor, in that order — the
// cradle is not fitted into a height, the height is made to hold the cradle
block_h = cradle_depth + floor_meat;

// Width of the cradle's mouth in the top face, before the rims are broken. Cut
// to half a cylinder, so it is exactly the cradle's diameter
mouth_w = 2 * cradle_r;

// Flat left of the top face either side of the cradle, once the outer chamfer
// has taken from one edge and the cradle's own ease from the other
rim = (block_w - mouth_w) / 2 - chamfer - cradle_ease;

// How far the pencil stands above the top face, resting on the arc. Half of it
// less whatever the clearance lets it settle, and it is what there is to pinch
// hold of
pencil_proud = pencil_d / 2 - pencil_clearance;

// Where the cradle's ease meets the arc. Held on the circle rather than guessed
// at, so the chamfer runs into the trough wall instead of leaving a step in it
ease_foot = sqrt(cradle_r * cradle_r - cradle_ease * cradle_ease);

// The punch. Its floor is the trough's deepest point written out again rather
// than a depth of its own, so the two are the same plane and no arithmetic
// stands between the punch and the floor it must not break
punch_floor = block_h - cradle_depth;
punch_depth = block_h - punch_floor;

// Diameter of the punch. What is left over once the outer chamfer, the flat and
// the punch's own ease have been taken off both sides, so the material outside
// it is punch_wall by construction and the sides are safe from any value
punch_d = block_w - 2 * (chamfer + punch_wall + punch_ease);
punch_mouth = punch_d + 2 * punch_ease;

// Material left between the punch's mouth and each end of the block
punch_end_meat = (block_l - punch_mouth) / 2 - chamfer;

// How much of the pencil's side a finger can close on at the punch. The floor
// of the punch is level with the underside of the pencil, so it is all of it
punch_grip = pencil_d;

overshoot = 1; // Run past both ends, so the trough cuts through cleanly

echo(str("block = ", block_w, " x ", block_l, " x ", block_h, " mm"));
echo(str("cradle = ", mouth_w, " mm across, ", cradle_depth, " mm deep"));
echo(str("floor under the cradle = ", floor_meat, " mm"));
echo(str("flat rim either side = ", rim, " mm"));
echo(str("pencil stands proud of the top face by = ", pencil_proud, " mm"));
echo(str("punch = ", punch_d, " mm across, ", punch_mouth, " mm at the mouth, ", punch_depth, " mm deep"));
echo(str("punch floor is level with the trough, on the same ", floor_meat, " mm of floor"));
echo(str("punch leaves ", punch_wall, " mm of flat either side and ", punch_end_meat, " mm at each end"));
echo(str("pencil exposed at the punch = ", punch_grip, " mm, its full diameter"));

assert(pencil_d > 0, "pencil_d has to be positive");
assert(cradle_r > 0, "pencil_clearance has closed the cradle — it cannot be more negative than the pencil is thick");
assert(floor_meat > 0, "floor_meat has to be positive — it is the whole floor under the cradle");
assert(rim > 0, "the cradle has eaten the top face — widen block_w, or reduce chamfer or cradle_ease");
assert(pencil_proud > 0, "the clearance has sunk the pencil below the top face — reduce pencil_clearance");
assert(cradle_ease < cradle_r, "the cradle's ease is wider than the cradle — reduce cradle_ease");
assert(punch_d > mouth_w, "the punch is no wider than the cradle, so it opens nothing a finger did not already have — widen block_w, or take it out of punch_wall");
assert(punch_end_meat > 0, "the punch has run out through the ends of the block — lengthen block_l, or widen punch_wall to narrow the punch");
assert(punch_ease < punch_depth, "the punch's ease is deeper than the punch — reduce punch_ease");
assert(2 * chamfer < block_w, "the width chamfers have met — reduce chamfer or widen block_w");
assert(2 * chamfer < block_l, "the length chamfers have met — reduce chamfer or lengthen block_l");
assert(2 * chamfer < block_h, "the height chamfers have met — reduce chamfer, or add floor_meat to make the block taller");

// A rectangle with all four corners cut at 45 deg, centred on the origin. Each
// corner takes the same amount off both edges, so the cut is 45 deg whatever
// chamfer is set to. Used three times, once per pair of faces, and the
// intersection of the three is a block with all twelve edges broken
module chamfered_rect_2d(across, up) {
  polygon([
    [-across / 2 + chamfer, -up / 2],
    [across / 2 - chamfer, -up / 2],
    [across / 2, -up / 2 + chamfer],
    [across / 2, up / 2 - chamfer],
    [across / 2 - chamfer, up / 2],
    [-across / 2 + chamfer, up / 2],
    [-across / 2, up / 2 - chamfer],
    [-across / 2, -up / 2 + chamfer],
  ]);
}

// The cradle, in cross section: x is across the width, y is up from the base.
// The circle sits on the top face, so half of it is in the block and half is
// in the air above it — that is the half cylinder, drawn rather than
// calculated. The trapezoid breaks both rims, and its lower corners are held
// on the circle so the break runs into the arc without a step
module cradle_2d() {
  circle(r = cradle_r);

  translate([0, -cradle_ease])
    polygon([
      [-ease_foot, 0],
      [ease_foot, 0],
      [cradle_r + cradle_ease, cradle_ease],
      [-cradle_r - cradle_ease, cradle_ease],
    ]);
}

// Run a cross section the length of the block, clear of both ends
module along_length(extra = 0) {
  translate([0, block_l / 2 + overshoot + extra, 0])
    rotate([90, 0, 0])
      linear_extrude(block_l + 2 * (overshoot + extra))
        children();
}

// Run a cross section across the width of the block, clear of both sides
module across_width(extra = 0) {
  translate([block_w / 2 + overshoot + extra, 0, 0])
    rotate([0, -90, 0])
      linear_extrude(block_w + 2 * (overshoot + extra))
        children();
}

// The block: three chamfered rectangles, one per pair of opposite faces,
// intersected. Each one breaks the four edges its own corners stand in for —
// the plan takes the uprights, and the two elevations take the top and bottom
// edges between them
module block_body() {
  intersection() {
    linear_extrude(block_h)
      chamfered_rect_2d(block_w, block_l);

    along_length()
      translate([0, block_h / 2])
        chamfered_rect_2d(block_w, block_h);

    across_width()
      translate([block_h / 2, 0])
        chamfered_rect_2d(block_h, block_l);
  }
}

module pencil_rest() {
  difference() {
    block_body();

    along_length(1)
      translate([0, block_h])
        cradle_2d();

    // The punch, from the trough's own floor up and out through the top
    translate([0, 0, punch_floor])
      cylinder(d = punch_d, h = punch_depth + overshoot);

    // Its rim, broken by a cone that opens upward. The cone's radial change
    // and its height are one expression, so it is 45 deg whatever punch_ease
    // is set to, and it can no more hang than the chamfers can
    translate([0, 0, block_h - punch_ease])
      cylinder(d1 = punch_d, d2 = punch_d + 2 * (punch_ease + overshoot), h = punch_ease + overshoot);
  }
}

pencil_rest();
