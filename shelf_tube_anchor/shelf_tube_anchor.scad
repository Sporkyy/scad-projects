// ============================================================
// Turn-N-Tube shelf wall anchor — collar with a zip tie bail
// Ties a vertical tube post back to the wall without the zip
// tie having to go around the post.
//
// A tie run straight from the wall around the post has to
// swallow the whole tube — a 30 mm post costs about 95 mm of
// tie before the tie has anchored anything. This is a plain
// collar that slips over the post and carries a lug standing
// off the wall side, with a channel through the lug that the
// tie threads. The tie then only has to reach the wall and
// back, so a much shorter tie does the job, and the loop that
// used to be strangling the post is a neat bar on one side.
//
// THE CHANNEL IS A U-TURN, AND IT HAS TO BE. A tie is a closed
// loop, so it has to come back on itself, and a channel bored
// straight at the wall cannot: its inner end runs into the
// post. Any channel that instead runs across the lug leaves
// the tie to make a right-angle turn over the mouth edge, with
// the corner carrying the whole redirection on a point.
//
// So the channel goes in and comes back out: two straight legs
// running out towards the wall, joined by a 180 deg bend at
// the inboard end. Both mouths face the wall, both legs leave
// pointing at whatever the tie is anchored to, and the only
// bend in the part is one smooth arc at a radius that is
// chosen rather than whatever a corner happened to be. Pulled
// tight, the bend bears on the island of material between the
// two legs across the whole half turn instead of on two corner
// tips.
//
// That island is what the tie is really holding, and it is
// held in turn by the decks above and below the channel. They
// are the load path out of the lug and into the ring.
//
// The channel's roof is a gable rather than a flat bridge, the
// same trick the zip tie corner blocks use, and it follows the
// bend the whole way round. It is 26.6 deg from vertical
// whatever the tie measures, so the channel carries itself and
// no value of tie_thickness can turn it into a bridge.
//
// The collar is deliberately taller than a coupler. The tie's
// pull is a radial tug at one point on a round post, which is
// a tipping load, and collar height is the only thing
// resisting it. It stands on the shelf below, which is what
// stops it sliding down the post.
//
// Modeled in its print orientation: collar axis vertical, flat
// on the plate.
//
// PRINT NOTES:
// - PETG, PLA or ASA, no supports needed.
// - Print as modeled, collar axis vertical. The bore then
//   prints round and slides onto the post, and the layers run
//   across the lug so the tie's pull is in the layer plane
//   rather than across the layer lines.
// - The worst overhang in the part is the channel's gable roof
//   at 26.6 deg from vertical. Everything else is vertical, on
//   the plate, or facing up.
// - 3 or 4 perimeters and 30% infill or more. The decks above
//   and below the channel are the only thing holding the
//   island on, and they are only deck thick.
// - Thread the tie in one mouth and out the other, then around
//   the wall fixture and into its own head. The head does not
//   fit through the channel and is not meant to — let it sit
//   out by the fixture.
// - The lug reaches lug_reach past the ring towards the wall,
//   so the post needs at least that much clear or the lug
//   lands on the wall instead of the tie.
// - Slips over the post from the end, so the shelf above has
//   to come off to fit one. Rests on the shelf below.
// ============================================================

// ===== MEASURE THESE ON YOUR ACTUAL SHELVES AND TIE =====
// Every one of these is an outside-the-solid measurement, so plain calipers
// reach them. Each names the caliper it needs by the size printed on the tool:
// a 6 in caliper stops at 150 mm, an 8 in at 200 mm, a 12 in at 300 mm

tube_od = 30; // Outer diameter of the vertical tube post (mm) — outside jaws on the tube, 6 in caliper

// Width of the tie's strap (mm) — outside jaws across the flat of the strap,
// 6 in caliper. Measure the plain strap well away from the head. This is the
// tall dimension of the channel, since the tie lies flat against the island
tie_width = 3.5;

// Thickness of the tie's strap (mm) — outside jaws on the edge of the strap,
// 6 in caliper. Take it over the ratchet teeth, not between them: the teeth
// are what has to clear the channel. Nominal 4.8 mm ties run anywhere from 1.1
// to 1.6 mm depending on how heavy the tie is, so measure the one you have
tie_thickness = 1.3;

// ===== DECIDE THESE =====
// Choices, not measurements

// Radius the tie is bent to at the U-turn, at the middle of the strap (mm).
// This is the knob the lug is built around. It sets three things at once: how
// gently the tie turns, how far apart the two mouths are, and how far the lug
// stands off the ring. It cannot go below min_bend_radius, which is echoed
// below — under that the island the tie pulls on is too thin to be a post
bend_radius = 4;

// Height of the collar (mm). The tie tugs the lug radially, which tries to tip
// the collar on the post, and this is what resists it — so this collar is
// taller than a coupler on purpose. It cannot go below min_collar_height,
// which is echoed below: the channel and its two decks have to fit inside it
collar_height = 12;

// ===== TUNE THESE =====
hole_clearance = 0.6; // Added to bore diameter for a slip fit over the post (mm) — increase if too tight
wall_meat = 5; // Thickness of the ring around the bore (mm)
tie_clearance = 0.6; // Added to both channel dimensions (mm) — the tie has to be threaded round a half turn by hand, so it wants slack rather than a press fit
straight_run = 3; // How far the mouths stand past the end of the bend (mm) — this is what aims the tie, so it is not decoration
outer_wall = 2; // Material outboard of each leg (mm) — the lug's two flanks
min_island = 3; // Least width allowed for the island between the legs (mm) — the tie pulls straight out on it, so it is a post, not a skin
min_deck = 1.6; // Least material allowed over the gable peak and under the channel floor (mm)
corner_round = 1.5; // Rounding on the lug's outboard corners and on the island's tip (mm) — the tie's legs bear on the island tip when the fixture sits close in, so it is a radius, not a decoration
fillet = 3; // Radius softening where the lug meets the ring (mm)

$fn = 100;

// ===== DERIVED =====
hole_r = tube_od / 2 + hole_clearance / 2;
collar_r = hole_r + wall_meat;

slot_w = tie_thickness + tie_clearance; // Channel across the strap's thickness
slot_h = tie_width + tie_clearance; // Channel across the strap's width, vertically

// Rise of the gable over the channel. It is a full slot width against a half
// slot width of run, so each roof face sits at 26.6 deg from vertical whatever
// the tie measures — no value of tie_thickness can turn this into a bridge
gable = slot_w;

// Material over the gable peak and under the channel floor. The channel stack
// is centred in the collar, so raising collar_height buys both decks equally
deck = (collar_height - slot_h - gable) / 2;
min_collar_height = slot_h + gable + 2 * min_deck;

// The island between the two legs — the post the tie's U-turn pulls on. A leg
// takes half a slot out of the bend's diameter on each side
island_width = 2 * bend_radius - slot_w;
min_bend_radius = (slot_w + min_island) / 2;

// Centre of the U-turn. Placed so the outermost wall of the bend is tangent to
// the ring, which is the closest in the channel can sit without eating into the
// ring's wall
bend_x = collar_r + bend_radius + slot_w / 2;

lug_x = bend_x + straight_run; // Outer face of the lug, where both mouths open
lug_reach = lug_x - collar_r; // How far the lug stands off the ring, towards the wall
lug_half = bend_radius + slot_w / 2 + outer_wall;
lug_width = 2 * lug_half; // How far the lug reaches along the ring

mouth_spacing = 2 * bend_radius; // Between the two mouths, middle of strap to middle of strap
overall_length = collar_r + lug_x;

// Tie swallowed by the lug itself: the half turn plus both straight legs
tie_in_lug = PI * bend_radius + 2 * straight_run;

// Shortest closed loop the channel will take, coming straight back on itself
// across the two mouths. The tie also has to reach the wall fixture and back
min_tie_loop = tie_in_lug + mouth_spacing;

mouth_over = 1; // Overshoot past the lug's outer face, so the mouths cut through cleanly
seam = 0.02; // Overlap where each straight leg meets the bend

// Channel cross section, drawn in the plane it is swept along: x runs across
// the strap's thickness, y is up. Square where the tie sits, gabled above it so
// the roof carries itself. Symmetric about x = 0, so the same profile serves
// both legs and the bend
channel_profile = [
  [-slot_w / 2, 0],
  [slot_w / 2, 0],
  [slot_w / 2, slot_h],
  [0, slot_h + gable],
  [-slot_w / 2, slot_h],
];

echo(str("collar = ", 2 * collar_r, " mm across the ring by ", collar_height, " mm tall, ", 2 * hole_r, " mm bore"));
echo(str("overall = ", overall_length, " x ", 2 * collar_r, " x ", collar_height, " mm"));
echo(str("lug reaches past the ring towards the wall by = ", lug_reach, " mm"));
echo(str("lug along the ring = ", lug_width, " mm"));
echo(str("channel = ", slot_w, " mm across the strap by ", slot_h, " mm tall"));
echo(str("island between the legs = ", island_width, " mm"));
echo(str("mouths = ", mouth_spacing, " mm apart, both facing the wall"));
echo(str("deck over the gable and under the channel floor = ", deck, " mm"));
echo(str("tie swallowed by the lug = ", tie_in_lug, " mm"));
echo(str("tie loop needed = ", min_tie_loop, " mm to come back on itself at the mouths, plus twice the reach to the wall fixture and around it"));
echo(str("smallest bend_radius this tie allows = ", min_bend_radius, " mm"));
echo(str("shortest collar_height this tie allows = ", min_collar_height, " mm"));

assert(deck >= min_deck, str("collar_height leaves less than min_deck over the gable or under the channel floor — raise collar_height to at least ", min_collar_height, " mm, or lower min_deck"));
assert(slot_w > 0 && slot_h > 0, "tie_clearance has closed the channel — it cannot be more negative than the tie is thick");
assert(bend_radius >= min_bend_radius, str("the two legs have eaten the island between them — raise bend_radius to at least ", min_bend_radius, " mm, or lower min_island"));
assert(straight_run > 0, "the mouths would open mid-bend and aim the tie across the lug instead of at the wall — raise straight_run");
assert(outer_wall > 0, "outer_wall has to be positive — a leg would open out of the side of the lug");
assert(wall_meat > 0, "wall_meat has to be positive — the ring needs a wall between the bore and the outside");
assert(corner_round <= outer_wall, "the corner rounding has broken into a leg at the mouth — lower corner_round or raise outer_wall");
assert(corner_round < island_width / 2, "the corner rounding has swallowed the island's tip — lower corner_round or raise bend_radius");
assert(corner_round < straight_run, "the corner rounding reaches back into the bend — lower corner_round or raise straight_run");
assert(lug_width < 2 * collar_r, "the lug is wider than the ring it sits on — lower bend_radius or outer_wall, or fatten the ring");
assert(fillet < collar_r, "fillet is larger than the ring — lower it");

// The lug, in plan. A rectangle reaching from inside the ring out to the face
// both mouths open on, with its two outboard corners rounded. The inboard end
// is buried in the ring
module lug_2d() {
  offset(r = corner_round)
    translate([0, -(lug_half - corner_round)])
      square([lug_x - corner_round, lug_width - 2 * corner_round]);
}

// Plan of the part: the ring with the lug on it, the two concave junctions
// filleted. Grow and shrink by the same radius, which fills a concave corner
// and hands a convex one back unchanged
module body_2d() {
  offset(r = -fillet)
    offset(r = fillet) {
      circle(r = collar_r);
      lug_2d();
    }
}

// One straight leg of the channel, running out towards the wall. The rotation
// maps the profile's x across the lug and its y up, and sweeps along +x
module channel_leg_3d() {
  translate([bend_x - seam, bend_radius, deck])
    rotate([90, 0, 90])
      linear_extrude(lug_x + mouth_over - bend_x + seam)
        polygon(channel_profile);
}

// The half turn that joins the two legs, tangent to both where it meets them
module channel_bend_3d() {
  translate([bend_x, 0, deck])
    rotate([0, 0, 90])
      rotate_extrude(angle = 180)
        translate([bend_radius, 0])
          polygon(channel_profile);
}

module channel_3d() {
  for(s = [-1, 1])
    mirror([0, (s + 1) / 2, 0])
      channel_leg_3d();

  channel_bend_3d();
}

// Rounding on one of the island's tip corners, cut the full height so the tip
// reads as one shape. The tie's legs bear here when the wall fixture sits close
// enough in for them to converge
module tip_round_quarter_3d() {
  translate([lug_x - corner_round, island_width / 2 - corner_round, -1])
    linear_extrude(collar_height + 2)
      difference() {
        square(corner_round);
        circle(r = corner_round);
      }
}

module shelf_tube_anchor() {
  difference() {
    linear_extrude(collar_height)
      body_2d();

    // Through-bore for the tube post
    translate([0, 0, -1])
      cylinder(r = hole_r, h = collar_height + 2);

    channel_3d();

    tip_round_quarter_3d();
    mirror([0, 1, 0])
      tip_round_quarter_3d();
  }
}

shelf_tube_anchor();
