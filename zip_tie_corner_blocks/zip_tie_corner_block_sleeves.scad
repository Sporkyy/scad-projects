// ============================================================
// Zip tie corner block sleeve — a TPU liner that goes between
// one leg of a corner block and the flat it bears on
//
// The block is rigid, and everything it presses against is a
// painted, powder-coated or anodized flat. This sleeve is the
// soft layer in between: it grips, it spreads the tie's load
// over a surface that is never quite flat, and it is the part
// that takes the scuffing instead of the finish underneath.
//
// It is a channel with three sides. The wide one is the pad,
// and it is the whole working surface — it lies on the block's
// inner face and bears on the object. The other two are lips
// that fold over the block's top and bottom faces and hold the
// sleeve there.
//
// The lips are not the fastening. Glue is. What they do is
// stop the sleeve sliding around while the glue is wet, and
// square it up on the face by themselves so there is nothing
// to line up by eye — TPU is printed a shade narrow across the
// channel and snaps onto the block, and the glue cures with
// everything already where it belongs.
//
// ONE LEG, ONE SLEEVE. A block has two inner faces, so it
// takes two of these, and a set of four blocks takes eight.
// They are all the same part: the channel is symmetric top to
// bottom and uniform end to end, so it has no handedness and
// no right way up.
//
// The sleeve stands the block off the flats by its own pad
// thickness, which lifts the tie the same amount. Nothing in
// the block minds, and the corner relief only gains clearance,
// but the echoed standoff below is the one the assembled joint
// actually has.
//
// THE PARAMETERS UP TO THE SECOND BLOCK BELOW ARE COPIES.
// They have to hold the same values as the block's, or the
// channel will not fit the block it was cut for. Change one
// and change it in both files.
//
// Modeled in its print orientation: pad flat on the plate,
// lips pointing up.
//
// PRINT NOTES:
// - TPU, no supports needed. Print as modeled, pad down.
// - Nothing in the part hangs, at all. Every face is vertical,
//   on the plate, or facing up — including the two lead-in
//   bevels at the lips, which taper the tips at 45 deg and so
//   point upward rather than down.
// - Pad down puts the plate's finish on the face that bears on
//   the object and leaves the printed top surface as the glue
//   face, which is the way round that suits both.
// - The block's foot chamfer leaves a groove along one edge
//   between the pad and the block. That is a glue reservoir,
//   not a gap to close.
// - 3 perimeters. At this size the lips are perimeters the
//   whole way through, which is what makes them springy rather
//   than crumbly.
// - Cyanoacrylate or contact cement. TPU takes both; the rigid
//   filament under it is what decides.
// - This source emits ONE sleeve. Print eight for a set of
//   four blocks.
// ============================================================

// ===== MEASURE THESE ON YOUR ACTUAL ZIP TIE =====
// The same two measurements the block is built from, and they set the height
// of the channel here. Each names the caliper it needs by the size printed on
// the tool: a 6 in caliper stops at 150 mm, an 8 in at 200 mm, a 12 in at
// 300 mm

// Width of the tie's strap (mm) — outside jaws across the flat of the strap,
// 6 in caliper. Measure the plain strap well away from the head
tie_width = 4.8;

// Thickness of the tie's strap (mm) — outside jaws on the edge of the strap,
// over the ratchet teeth rather than between them, 6 in caliper
tie_thickness = 1.4;

// ===== THESE MUST MATCH THE BLOCK =====
// Copies of the block's knobs, carried here because the sleeve has to come out
// the same size as the block it wraps. Nothing below is a free choice: read
// each one off the block's source and keep the two files in step

tie_clearance = 0.6; // The block's channel clearance — feeds the block height
deck = 1.6; // The block's top and bottom skins — feeds the block height
leg_length = 14; // How far the block reaches along each flat
corner_relief_d = 4; // The block's corner relief — where its inner face starts
bend_radius = 10; // The block's bend radius — feeds the leg thickness
corner_web = 2.5; // The block's corner web — feeds the leg thickness
outer_wall = 2.4; // The block's outer flange — feeds the leg thickness
foot_chamfer = 0.6; // The block's foot chamfer — the groove it leaves is the glue reservoir

// ===== DECIDE THESE =====
// The sleeve's own shape

// Thickness of the pad (mm). All of the cushion and all of the grip is this
// number, and it is also how far the block is stood off the flat. It has to
// stay under the corner relief radius or the two sleeves on one block meet at
// the corner
pad_thickness = 1.6;

// How far each lip folds over the block's top and bottom faces (mm). Enough to
// hold the sleeve square while the glue goes off; it does not have to reach
// far, and it must not reach past the back of the leg
lip_reach = 3;

// Thickness of each lip (mm). Thin enough to spring over the block, thick
// enough not to tear off it
lip_thickness = 1.2;

// ===== TUNE THESE =====
block_pinch = 0.2; // SUBTRACTED from the block height (mm) — the channel is printed narrow and stretched on, so it holds itself in place before it is glued
lip_lead_in = 0.6; // Taper at the mouth of each lip (mm) — how far out of square the sleeve can start and still snap on

// ===== DERIVED =====
slot_w = tie_thickness + tie_clearance;
slot_h = tie_width + tie_clearance;
gable = slot_w;
relief_r = corner_relief_d / 2;

// The block's height, rebuilt from the same numbers the block builds it from.
// This is the dimension the channel has to match, so check it against the
// block's own echo
block_h = 2 * deck + slot_h + gable;

// The block's leg thickness, rebuilt the same way. The lips fold over this
// face, so it is the room they have
tie_offset = ((sqrt(2) - 1) * bend_radius + slot_w / 2 + relief_r + corner_web) / sqrt(2);
face_offset = tie_offset - slot_w / 2;
leg_thickness = face_offset + slot_w + outer_wall;

// Length of the block's inner face, from where the corner relief lets go of it
// to the end of the leg. The sleeve covers all of it and no more
sleeve_length = leg_length - relief_r;

// Clear width of the channel. Narrower than the block by the pinch, which is
// what the lips have to stretch over
gap = block_h - block_pinch;

sleeve_width = gap + 2 * lip_thickness;
sleeve_height = pad_thickness + lip_reach;

// Where the tie ends up once the sleeves are on: the block's own standoff plus
// the pad under it. This is the height the tie rides above each flat on the
// runs between blocks
sleeved_face_offset = face_offset + pad_thickness;

// What is left of the block's top and bottom faces outside each lip. The lip
// folds over the face, not around the back of it
lip_clearance = leg_thickness - lip_reach;

echo(str("sleeve = ", sleeve_width, " x ", sleeve_length, " x ", sleeve_height, " mm"));
echo(str("channel = ", gap, " mm clear, onto a ", block_h, " mm block"));
echo(str("pad covers ", sleeve_length, " mm of face, ", pad_thickness, " mm thick"));
echo(str("lip folds ", lip_reach, " mm over a ", leg_thickness, " mm leg, leaving ", lip_clearance, " mm"));
echo(str("glue groove along the chamfered edge = ", foot_chamfer, " mm"));
echo(str("tie stands off each flat by = ", sleeved_face_offset, " mm once sleeved"));
echo("print eight for a set of four blocks");

assert(pad_thickness > 0, "pad_thickness has to be positive — the pad is the whole point of the sleeve");
assert(pad_thickness < relief_r, "the two sleeves on one block would meet at the corner — thin the pad, or open corner_relief_d in both files");
assert(lip_thickness > 0, "lip_thickness has to be positive");
assert(lip_reach > 0, "lip_reach has to be positive — without the lips this is a shim, and it will not stay put");
assert(lip_clearance > 0, "the lips reach past the back of the leg — reduce lip_reach");
assert(gap > 0, "block_pinch has closed the channel — it cannot be more negative than the block is tall");
assert(block_pinch >= 0, "a negative block_pinch is slack, and slack is what the lips are there to remove — leave it at 0 for a slip fit");
assert(sleeve_length > 0, "the corner relief has eaten the whole inner face — lengthen leg_length or reduce corner_relief_d, in both files");
assert(lip_lead_in < lip_thickness, "the lead-in has tapered the lip to nothing — reduce lip_lead_in");
assert(lip_lead_in < lip_reach, "the lead-in is deeper than the lip is long — reduce lip_lead_in");

// The pad, in cross section: x is across the block's height, y is up out of
// the plate. It runs the full width so the lips land on it rather than beside
// it
module pad_2d() {
  translate([-sleeve_width / 2, 0])
    square([sleeve_width, pad_thickness]);
}

// One lip, in the same cross section. It starts at the plate and overlaps the
// pad rather than sitting on top of it, so the two meet in material. The
// lead-in takes the inner corner off the tip: it moves out and up by the same
// amount, so it is 45 deg whatever lip_lead_in is set to, and it funnels the
// mouth rather than closing it
module lip_2d() {
  inner = gap / 2;
  outer = gap / 2 + lip_thickness;
  polygon([
    [inner, 0],
    [outer, 0],
    [outer, sleeve_height],
    [inner + lip_lead_in, sleeve_height],
    [inner, sleeve_height - lip_lead_in],
  ]);
}

// Everything here is one cross section run the length of the block's inner
// face
module along_leg() {
  translate([0, sleeve_length, 0])
    rotate([90, 0, 0])
      linear_extrude(sleeve_length)
        children();
}

// Three sides: the pad, and a lip either side of it. The second lip is the
// first mirrored, so the channel cannot come out lopsided
module zip_tie_corner_block_sleeve() {
  union() {
    along_leg()
      pad_2d();
    along_leg()
      lip_2d();
    mirror([1, 0, 0])
      along_leg()
        lip_2d();
  }
}

zip_tie_corner_block_sleeve();
