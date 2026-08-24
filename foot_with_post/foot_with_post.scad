// ============================================================
// Foot with post — a TPU foot that plugs into a socket in the
// bottom of whatever it is holding up
//
// Two stacked cylinders on one axis. The lower, wider one is
// the foot: it stands on the floor, lifts the object by its
// own height, and being TPU it grips and it damps. The upper,
// narrower one is the post: it is a plug for the hole already
// in the bottom of the object, and it is the only thing
// holding the foot on.
//
// The step between the two is the shoulder, and it is what the
// object actually rests on. The post carries no load down the
// axis — it is there so the foot cannot walk out from under
// the object or fall off when the thing is picked up.
//
// The foot's bottom rim is chamfered. TPU squashes its first
// layer more than a rigid filament does, and a foot is the one
// part where a flared elephant foot is guaranteed to be the
// surface bearing on the floor. The chamfer gives that squash
// somewhere to go.
//
// The post's top rim is chamfered too, for a different reason:
// it is a lead-in. A soft post pushed at a hole it is not
// quite lined up with folds over instead of entering, so the
// tip is made smaller than the hole and grows into it.
//
// The socket is a hole that opens at the bottom face of the
// object, so the caliper's inside jaws and depth rod both
// reach it. The post is never measured — it is the socket plus
// an interference knob, because TPU is fitted by squeezing it
// rather than by clearing it.
//
// Modeled in its print orientation: foot on the plate, post
// pointing up.
//
// PRINT NOTES:
// - TPU, no supports needed. Print as modeled, foot down.
// - Nothing in the part hangs. The post's top chamfer closes
//   inward, the shoulder faces up, and the only downward face
//   is the foot's bottom chamfer at 45 deg, in the first
//   millimetre or two off the plate.
// - Both chamfers are written with their radial run equal to
//   their rise, so no value either knob is given can turn one
//   into an overhang.
// - Slow it down. TPU at speed under-extrudes on the small
//   circumference of the post, and the post is the part that
//   has to hold.
// - Infill is the squish. A foot printed at 15% gives under
//   weight and one printed solid barely does, and neither is
//   wrong — it is what the foot is for. 3 perimeters either
//   way, so the post has walls rather than infill in it.
// - Print the set together and they come out the same height.
//   Printed one at a time they will not, quite.
// ============================================================

// ===== MEASURE THESE ON THE OBJECT THE FOOT GOES UNDER =====
// The socket opens at the bottom face, so both of these are reachable with an
// ordinary caliper. Each names the caliper it needs by the size printed on the
// tool: a 6 in caliper stops at 150 mm, an 8 in at 200 mm, a 12 in at 300 mm

// Diameter of the socket in the bottom of the object (mm) — inside jaws in the
// hole, 6 in caliper. Open the jaws against the wall of the hole and take it at
// a couple of rotations; an injection-molded socket is often slightly oval, and
// here it is the SMALLEST reading that matters, since that is what the post has
// to pass
socket_d = 12;

// Depth of that socket (mm) — depth rod at the tail of the caliper, down the
// hole until it stops, 6 in caliper. Only used to check that the post is not
// longer than the hole it goes in
socket_depth = 20;

// ===== DECIDE THESE =====
// Choices, not measurements — the foot is whatever these make it

// Diameter of the foot (mm). The contact patch on the floor, and the shoulder
// the object sits on. Wider spreads the load and resists rocking; it also has
// to clear whatever else is on the underside of the object
foot_d = 30;

// Height of the foot (mm). How far the object is lifted, and how much rubber
// there is to squash under it
foot_h = 8;

// Height of the post (mm). How far it reaches into the socket. It grips over
// its whole length, so most of the socket is worth using — the assert below
// keeps it from bottoming out before the shoulder seats
post_h = 15;

// ===== TUNE THESE =====
post_interference = 0.2; // ADDED to the socket diameter (mm) — the post is printed oversize and squeezed in. Raise for more grip, drop toward 0 if it will not start, go negative only if the socket is soft too
foot_chamfer = 1.5; // Break on the foot's bottom rim (mm) — room for TPU to spread into on the first layer
post_chamfer = 1; // Lead-in on the post's top rim (mm) — how far off center the post can start and still find the hole

// How far the post's base is buried in the foot (mm). Nothing to do with the
// fit — it is there so the union has material to work with rather than two
// faces landing on the same plane
post_overlap = 0.01;

$fn = 100;

// ===== DERIVED =====
post_d = socket_d + post_interference;
total_height = foot_h + post_h;

// Width of the ring the object rests on. This is the whole load path from the
// object into the foot, and it is what a foot barely wider than its own post
// runs out of
shoulder = (foot_d - post_d) / 2;

// Flat left on the floor once the chamfer has taken the rim. The foot stands on
// this and the first layer is this wide, so a generous chamfer on a narrow foot
// costs bed adhesion on the one part that is nothing but bed adhesion
foot_contact_d = foot_d - 2 * foot_chamfer;

// Air left at the bottom of the socket with the shoulder seated. It has to be
// positive or the post reaches the end of the hole first and holds the object
// off its own foot
seat_gap = socket_depth - post_h;

echo(str("overall height = ", total_height, " mm"));
echo(str("post diameter = ", post_d, " mm into a ", socket_d, " mm socket"));
echo(str("shoulder ring = ", shoulder, " mm"));
echo(str("contact patch on the floor = ", foot_contact_d, " mm across"));
echo(str("air under the post when seated = ", seat_gap, " mm"));

assert(foot_h > 0, "foot_h has to be positive — there is no foot without one");
assert(post_h > 0, "post_h has to be positive — there is nothing holding the foot on without one");
assert(post_d > 0, "post_interference has closed the post — it cannot be more negative than the socket is wide");
assert(shoulder > 0, "the foot is no wider than the post — widen foot_d, or this is just a plug");
assert(foot_contact_d > 0, "the bottom chamfer has eaten the whole contact patch — reduce foot_chamfer or widen foot_d");
assert(foot_chamfer < foot_h, "the bottom chamfer is taller than the foot — reduce foot_chamfer or raise foot_h");
assert(2 * post_chamfer < post_d, "the top chamfer has closed the post to a point — reduce post_chamfer");
assert(post_overlap > 0 && post_overlap < foot_h, "post_overlap has to be a sliver, and it has to fit inside the foot");
assert(post_chamfer < post_h, "the lead-in is longer than the post — reduce post_chamfer or raise post_h");
assert(seat_gap > 0, "the post is longer than the socket is deep — it bottoms out before the shoulder seats, so reduce post_h");

// The foot: a cylinder standing on the plate with its bottom rim broken. x is
// radius out from the axis, y is height up from the floor. The chamfer moves
// out and up by the same amount, so it sits at 45 deg whatever foot_chamfer
// says
module foot_body() {
  r = foot_d / 2;
  rotate_extrude()
    polygon([
      [0, 0],
      [r - foot_chamfer, 0],
      [r, foot_chamfer],
      [r, foot_h],
      [0, foot_h],
    ]);
}

// The post: a narrower cylinder stacked on the foot, its top rim broken the
// same way to lead it into the socket. Its base sits inside the foot rather
// than on top of it, so the two solids meet in material instead of on a
// coincident face
module post_body() {
  r = post_d / 2;
  translate([0, 0, foot_h - post_overlap])
    rotate_extrude()
      polygon([
        [0, 0],
        [r, 0],
        [r, post_h + post_overlap - post_chamfer],
        [r - post_chamfer, post_h + post_overlap],
        [0, post_h + post_overlap],
      ]);
}

module foot_with_post() {
  union() {
    foot_body();
    post_body();
  }
}

foot_with_post();
