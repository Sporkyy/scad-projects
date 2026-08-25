// ============================================================
// Turn-N-Tube shelf wall anchor — collar with a zip tie lug
// Ties a vertical tube post back to the wall without the zip
// tie having to go around the post.
//
// A tie run straight from the wall around the post has to
// swallow the whole tube — a 30 mm post costs about 95 mm of
// tie before the tie has anchored anything. This is a plain
// collar that slips over the post and carries a lug standing
// off one side, with a tunnel through the lug that the tie
// threads. The tie then only has to reach the wall and back,
// so a much shorter tie does the job, and the loop that used
// to be strangling the post is now a neat bar on one side.
//
// The tunnel runs ALONG the ring rather than out towards the
// wall, because a tie has to come back on itself to close.
// Threaded through, it wraps the web of material between the
// tunnel and the lug's outer face and closes around whatever
// is on the wall — an eye screw, a hook, a bracket, a tie
// already around a pipe. The web is the whole load path: the
// tie pulls it straight out towards the wall and the decks
// above and below the tunnel hold it.
//
// The tunnel's roof is a gable rather than a flat bridge, the
// same trick the zip tie corner blocks use. It is 26.6 deg
// from vertical whatever the tie measures, so the tunnel
// carries itself and no value of tie_thickness can turn it
// into a bridge.
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
// - The worst overhang in the part is the tunnel's gable roof
//   at 26.6 deg from vertical. Everything else is vertical, on
//   the plate, or facing up.
// - 3 or 4 perimeters and 30% infill or more. The decks above
//   and below the tunnel are what hold the web on, and they
//   are only deck thick.
// - Thread the tie through the tunnel, around the wall
//   fixture, and back into its own head. The head does not fit
//   through the tunnel and is not meant to — sit it on the
//   outer face of the lug or out by the wall.
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
// tall dimension of the tunnel, since the tie lies flat against the web
tie_width = 3.5;

// Thickness of the tie's strap (mm) — outside jaws on the edge of the strap,
// 6 in caliper. Take it over the ratchet teeth, not between them: the teeth
// are what has to clear the tunnel. Nominal 4.8 mm ties run anywhere from 1.1
// to 1.6 mm depending on how heavy the tie is, so measure the one you have
tie_thickness = 1.3;

// ===== DECIDE THESE =====
// Choices, not measurements

// Height of the collar (mm). The tie tugs the lug radially, which tries to
// tip the collar on the post, and this is what resists it. It cannot go below
// min_collar_height, which is echoed below — the tunnel and its decks have to
// fit inside it
collar_height = 10;

// How far the lug reaches along the ring (mm), which is also the length of the
// tunnel. Longer spreads the tie's pull over more web and holds the tie's two
// legs further apart; shorter is a smaller bump and a shorter tie loop
lug_width = 12;

// ===== TUNE THESE =====
hole_clearance = 0.6; // Added to bore diameter for a slip fit over the post (mm) — increase if too tight
wall_meat = 5; // Thickness of the ring around the bore (mm)
tie_clearance = 0.6; // Added to both tunnel dimensions (mm) — the tie has to be threaded through by hand, so it wants slack rather than a press fit
tie_web = 2.5; // Material between the tunnel and the lug's outer face (mm) — the tie pulls straight out on this, so it is the load path, not a skin
min_deck = 1.6; // Least material allowed over the gable peak and under the tunnel floor (mm)
lug_corner = 2; // Rounding on the lug's two outboard corners (mm) — the tie bends over these on its way to the wall, so it is a radius, not a decoration
fillet = 3; // Radius softening where the lug meets the ring (mm)

$fn = 100;

// ===== DERIVED =====
hole_r = tube_od / 2 + hole_clearance / 2;
collar_r = hole_r + wall_meat;

slot_w = tie_thickness + tie_clearance; // Tunnel across the strap's thickness, radially
slot_h = tie_width + tie_clearance; // Tunnel across the strap's width, vertically

// Rise of the gable over the tunnel. It is a full slot width against a half
// slot width of run, so each roof face sits at 26.6 deg from vertical whatever
// the tie measures — no value of tie_thickness can turn this into a bridge
gable = slot_w;

// Material over the gable peak and under the tunnel floor. The tunnel stack is
// centred in the collar, so raising collar_height buys both decks equally
deck = (collar_height - slot_h - gable) / 2;
min_collar_height = slot_h + gable + 2 * min_deck;

// The tunnel's inner wall is tangent to the ring, so the tunnel never eats
// into the ring's wall and the bump is the only thing standing off it
channel_r = collar_r + slot_w / 2; // Radius to the middle of the strap
lug_reach = slot_w + tie_web; // How far the bump stands off the ring
lug_x = collar_r + lug_reach; // Outer face of the bump

overall_length = collar_r + lug_x;

// Perimeter of the web the tie wraps. This is the loop with nothing in it —
// the tie also has to take in the wall fixture and the run out to it
web_wrap = 2 * (lug_width + tie_web);

mouth_over = 1; // Overshoot past the lug's ends, so the tunnel cuts through cleanly

// Tunnel cross section, drawn in the plane it is swept along: x is radial,
// across the strap's thickness, and y is up. Square where the tie sits, gabled
// above it so the roof carries itself
channel_profile = [
  [-slot_w / 2, 0],
  [slot_w / 2, 0],
  [slot_w / 2, slot_h],
  [0, slot_h + gable],
  [-slot_w / 2, slot_h],
];

echo(str("collar = ", 2 * collar_r, " mm across the ring by ", collar_height, " mm tall, ", 2 * hole_r, " mm bore"));
echo(str("overall = ", overall_length, " x ", 2 * collar_r, " x ", collar_height, " mm"));
echo(str("lug stands off the ring by = ", lug_reach, " mm"));
echo(str("tunnel = ", slot_w, " mm across the strap by ", slot_h, " mm tall"));
echo(str("deck over the gable and under the tunnel floor = ", deck, " mm"));
echo(str("shortest collar_height this tie allows = ", min_collar_height, " mm"));
echo(str("tie loop needed = ", web_wrap, " mm around the web, plus the wall fixture and the reach to it"));

assert(deck >= min_deck, str("collar_height leaves less than min_deck over the gable or under the tunnel floor — raise collar_height to at least ", min_collar_height, " mm, or lower min_deck"));
assert(slot_w > 0 && slot_h > 0, "tie_clearance has closed the tunnel — it cannot be more negative than the tie is thick");
assert(tie_web > 0, "tie_web has to be positive — the tie pulls straight out on it");
assert(wall_meat > 0, "wall_meat has to be positive — the ring needs a wall between the bore and the outside");
assert(lug_width < 2 * collar_r, "the lug is wider than the ring it sits on — narrow lug_width or fatten the ring");
assert(lug_corner <= tie_web, "the corner rounding has opened the web at the tunnel mouths — lower lug_corner or raise tie_web");
assert(lug_corner < lug_width / 2, "the corner rounding has swallowed the lug's outer face — lower lug_corner or widen lug_width");
assert(fillet < collar_r, "fillet is larger than the ring — lower it");

// The bump, in plan. A rectangle reaching from inside the ring out to the
// lug's outer face, with its two outboard corners rounded so the tie bends
// over a radius on its way to the wall. The inboard end is buried in the ring
module lug_2d() {
  offset(r = lug_corner)
    translate([0, -(lug_width / 2 - lug_corner)])
      square([lug_x - lug_corner, lug_width - 2 * lug_corner]);
}

// Plan of the part: the ring with the bump on it, the two concave junctions
// filleted. Grow and shrink by the same radius, which fills a concave corner
// and hands a convex one back unchanged
module body_2d() {
  offset(r = -fillet)
    offset(r = fillet) {
      circle(r = collar_r);
      lug_2d();
    }
}

// The tie's tunnel, swept along the ring rather than out towards the wall
module channel_3d() {
  translate([channel_r, lug_width / 2 + mouth_over, deck])
    rotate([90, 0, 0])
      linear_extrude(lug_width + 2 * mouth_over)
        polygon(channel_profile);
}

module shelf_tube_anchor() {
  difference() {
    linear_extrude(collar_height)
      body_2d();

    // Through-bore for the tube post
    translate([0, 0, -1])
      cylinder(r = hole_r, h = collar_height + 2);

    channel_3d();
  }
}

shelf_tube_anchor();
