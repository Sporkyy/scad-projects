// ============================================================
// openGrid magnet snap, back face — a full-thickness snap
// carrying a disc magnet in a blind bore.
//
// THIS IS THE VARIANT WHOSE MAGNET IS ON THE BACK FACE: the
// narrow end of the shank, which is the end that runs into the
// tile and comes to rest against whatever the tile is mounted
// on. Its sibling opengrid_magnet_snap_front.scad puts the
// magnet on the front instead, facing you.
//
// This is the one that sticks a tile to steel, because its
// magnet is on the face the steel is against.
//
// FRONT AND BACK, ON A SNAP, MEAN THE WIDE END AND THE NARROW
// END. A full snap is 6.8 mm of two halves: 3.4 mm of business
// end carrying the corner ears and the face nubs, and 3.4 mm of
// plain shank behind it. The shank is what goes into the tile,
// so the wide end stays on the side you pushed from and faces
// you — the front — and the narrow end runs away from you
// toward whatever the tile is mounted on — the back. Measured
// on the mesh, the front reaches 15.4 mm from the axis at the
// ears and the shank only 14.53 mm.
//
// That split is also why a Heavy tile has two fronts and no
// back. 3.4 plus 3.4 is 6.8, so a Heavy cell takes either one
// full snap or two Lite snaps pushed in from opposite faces,
// and either way every ear ends up facing outward.
//
// openGrid snaps normally present a connector on their front
// face: threads, an openConnect head, a zip tie bail. This one
// presents a magnet instead. Drop it into any cell of a Heavy
// (6.8 mm) board and that cell becomes a magnetic pad, so the
// board can hang off any steel surface with no fastener and no
// adhesive.
//
// It exists to hang an openGrid tile under the top plate of a
// steel speaker stand, where the tile carries an Underware
// cable channel. The cells that are not doing cable duty become
// magnets, and the tile holds itself up.
//
// THIS VARIANT GETS ITS PRINT ORIENTATION FOR FREE. The bore
// has to open upward, because a 10.2 mm circular ceiling is not
// something to bridge. The bore is on the back face, so the
// back face goes up — and that is the same way up the snap
// wanted anyway, because the relief slots that free the four
// arms open out of the back face and so have no roof at all
// this way round. Nothing in the part is left hanging.
//
// The front variant gets no such luck. Its bore and its slots
// want opposite ends up, and it ships four flat 0.6 mm roofs as
// a result. If either variant would do the job, use this one.
//
// An optional hole runs from the floor of the bore out through
// the front face. It vents the bore, so cyanoacrylate cannot
// hydraulic-lock against the magnet and push it back out while
// it cures; it pushes a magnet out again if one has to come
// apart; and it passes a fastener, so the magnet can be a
// bolted pot magnet rather than a plain disc. Set through_hole
// false when the magnet is going on with an adhesive dot, which
// needs no vent and leaves a tidier face.
//
// Polarity does not matter. These stick to steel, not to each
// other, so a snap fitted the other way round holds exactly as
// well.
//
// THE SNAP PROFILE IS NOT ORIGINAL WORK. It is the openGrid
// standard snap, reproduced here from mitufy's parametric
// generator so that this file can stand alone:
//   https://github.com/mitufy/opengrid-projects  (CC BY 4.0)
// openGrid itself is by David D — https://www.opengrid.world
// The dimensions in the openGrid interface block below are that
// standard. They are not tuning knobs and changing one makes a
// snap that does not fit a board.
//
// ONE THING HERE DEPARTS FROM THE STANDARD, AND IT IS HIDDEN.
// The official snap's relief groove has a flat roof, which is a
// 90 deg ceiling whichever way up the snap is printed. Here that
// roof is a gable instead. The change is entirely inboard of the
// face plane — the groove's mouth is still the standard 0.4 mm
// tall by 0.8 mm deep, so a board cannot tell the difference —
// and it takes about 2 cubic mm out of each arm root, in a
// pocket that exists to be empty.
//
// PRINT NOTES:
// - PETG, PLA or ASA, no supports needed.
// - Print as modeled, front face down. The worst overhang is then
//   45 deg, at the groove gable, with the nub faces behind it at
//   35 deg. Flipped, the relief slots turn into flat 90 deg
//   ceilings 12.4 mm across, so do not let the slicer lay it the
//   other way up.
// - 4 perimeters, 30% infill or more. The four arms are what
//   the snap fit lives in and they are thin.
// - No brim needed, but the ears are the only thing touching
//   the plate at full width — make sure the first layer is
//   properly squished or they will lift.
// - Drop the magnet in after printing, bore side up. With the
//   through hole on, wick a little thin CA down it from the ear
//   side rather than puddling glue in the bore. With it off,
//   use an adhesive dot: a blind bore has nowhere to vent, and
//   a slug of CA under a disc will lift it back out.
// - Fit the snap to the board from the working-face side, the
//   same way any openGrid snap goes in. The ears pass the cell
//   and spring out behind it.
// ============================================================

// ===== MEASURE THESE ON YOUR ACTUAL MAGNETS =====
// Both are outside-the-solid measurements, so plain calipers reach them. Each
// names the caliper it needs by the size printed on the tool: a 6 in caliper
// stops at 150 mm, an 8 in at 200 mm, a 12 in at 300 mm

magnet_d = 10; // Diameter of the disc magnet (mm) — outside jaws across the disc, 6 in caliper

// Thickness of the disc magnet (mm) — outside jaws on the edge of the disc,
// 6 in caliper. Take it on the plain edge. Plated magnets vary by a couple of
// tenths between nominally identical discs, so measure the ones you have
// rather than trusting the listing
magnet_h = 3;

// ===== TUNING KNOBS =====

// Radial slip fit around the magnet (mm), added to the diameter. The magnet
// wants to drop in without being pressed — a press fit on a brittle plated
// disc chips the plating and the chip is what breaks the bond later
magnet_fit = 0.2;

// How far the magnet sits below the face it opens on (mm). Zero puts it
// flush, which is what lets it touch the steel directly. Going negative
// stands it proud, which grips harder but leaves the magnet to take the
// scuffing instead of the snap
magnet_recess = 0;

// Whether to run a hole all the way through, from the floor of the bore out
// the front face. It does three jobs: it vents the bore, so cyanoacrylate cannot
// hydraulic-lock against the magnet and push it back out while it cures; it
// lets a magnet be pushed back out if one ever has to come apart; and it
// passes a fastener, so the magnet can be a bolted pot magnet rather than a
// plain disc. Turn it off when the magnet is going on with an adhesive dot —
// a dot needs no vent, and the unbroken face is tidier
through_hole = true;

// Diameter of that hole (mm). 3 mm clears an M3 with room to spare. The bore
// is on the back here, so the hole comes out the front and a bolt head lands
// there — proud of a board the snap is flush in, so countersink it or use a
// magnet whose fastener does not need a head on that side
through_hole_d = 3;

// ===== openGrid INTERFACE — THE STANDARD, NOT KNOBS =====
// Reproduced from mitufy's generator. A board is 28 mm pitch and a Heavy
// board is 6.8 mm thick, and every number here follows from that. Change one
// and the snap stops fitting a board

snap_thickness = 6.8; // Heavy / Standard board thickness
snap_across_flats = 24.8; // Body width across its flat faces
snap_corner_chamfer = 2.7 * sqrt(2) + 1; // Leg of the 45 deg corner chamfer

ear_height = 1.5; // How tall each corner ear is
ear_reach = 1.1; // How far an ear stands off its chamfer face
ear_tip_height = 0.4; // Height of the ear's full-reach tip, before the 45 deg taper

nub_height = 2; // How tall each face nub is
nub_reach = 0.4; // How far a nub stands off its face
nub_base_width = 10.8; // Nub width where it leaves the face
nub_tip_width = 6.8; // Nub width at full reach, before the tip rounding
nub_tip_radius = 15; // Rounding blending the nub tip into its sides
nub_face_angle = 35; // Nub top and bottom faces, degrees from vertical
nub_offset_to_front = 1.4; // Gap between the nub and the front face

slot_length = 12.4; // Length of the relief slot that frees each arm
slot_width = 0.6; // Radial width of the relief slot
slot_wall = 0.7; // Material left outboard of the slot — this is the arm
slot_offset_to_front = 0.6; // How far the slot stops short of the front face

groove_length = 12.4; // Length of the shallow groove above each slot
groove_depth = 0.8; // How far the groove cuts into the face
groove_height = 0.4; // Height of the groove
groove_offset_to_front = 0.8; // How far the groove sits from the front face

// ===== DERIVED =====

half_flat = snap_across_flats / 2;
octagon_x = half_flat - snap_corner_chamfer; // Where a chamfer meets a flat

// Distance from the axis out to a chamfer face, which is where an ear stands
chamfer_face = (half_flat + octagon_x) / sqrt(2);

ear_base_width = snap_corner_chamfer * sqrt(2); // Ear width at the chamfer face
ear_tip_width = ear_base_width - 2 * ear_reach; // 45 deg taper on each side
ear_taper = ear_height - ear_tip_height; // Vertical run of the 45 deg underside

// A nub's top and bottom close in as it reaches out, so its tip is shorter
// than its base
nub_tip_height = nub_height - 2 * nub_reach / tan(nub_face_angle);

// How fast a nub's sides close in, as lateral run per unit of reach
nub_side_slope = (nub_base_width - nub_tip_width) / 2 / nub_reach;

// The tip rounding is one arc tangent to both the tip face and the sloped
// side. Tangency to the tip face puts its centre a full radius back; tangency
// to the side then fixes the centre laterally, so the arc cannot float free
// of either face whatever radius is asked for
nub_arc_reach = nub_reach - nub_tip_radius;
nub_arc_x = nub_base_width / 2 - nub_side_slope * nub_arc_reach - nub_tip_radius * sqrt(1 + nub_side_slope * nub_side_slope);
nub_arc_sweep = atan2(1, nub_side_slope); // Where the arc leaves the side

nub_bottom = nub_offset_to_front; // Front face is the datum, and it is on the plate
nub_centre_z = nub_bottom + nub_height / 2;

bore_d = magnet_d + magnet_fit;
bore_depth = magnet_h + magnet_recess;
bore_floor = snap_thickness - bore_depth; // Material left under the magnet

$fa = 1;
$fs = 0.25;
eps = 0.01;

// ===== SANITY CHECKS =====

assert(bore_floor >= 1.2, "Magnet bore leaves too little floor — use a thinner magnet");
assert(bore_d / 2 < half_flat - slot_wall - slot_width, "Magnet bore breaks into the relief slots — use a smaller magnet");
assert(!through_hole || through_hole_d < bore_d, "Through hole is wider than the magnet bore");

// magnet_recess going negative stands the magnet proud, which is a legitimate
// thing to want, but the bore still has to hold it. Half the disc buried is
// the point where the pocket stops being a pocket
assert(bore_depth >= magnet_h / 2, "Magnet stands more than half proud — the bore cannot hold it");

// The ear underside runs ear_reach outward while rising ear_taper, so it is
// 45 deg exactly when the two agree. Assert it rather than trusting the two
// knobs to stay in step, since an ear that tapers slower than this hangs
assert(ear_taper == ear_reach, "Ear underside is no longer 45 deg — ear_height minus ear_tip_height must equal ear_reach");
assert(nub_face_angle <= 45, "Nub faces are past 45 deg from vertical");

echo(str("Body: ", snap_across_flats, " mm across flats, ", snap_thickness, " mm thick"));
echo(str("Ear reach past the chamfer face at radius ", chamfer_face, ": ", ear_reach, " mm"));
echo(str("Nub tip: ", nub_tip_height, " mm tall at ", nub_reach, " mm reach"));
echo(str("Magnet bore: ", bore_d, " mm dia x ", bore_depth, " mm deep"));
echo(str("Floor under the magnet: ", bore_floor, " mm"));
echo(str("Through hole: ", through_hole ? str(through_hole_d, " mm dia") : "none, magnet goes on with adhesive"));

// ===== GEOMETRY =====
// Modeled in its print orientation: front face on the plate at z = 0, working
// face and its magnet bore facing up

module body() {
  linear_extrude(height = snap_thickness)
    polygon([
      [half_flat, octagon_x],
      [octagon_x, half_flat],
      [-octagon_x, half_flat],
      [-half_flat, octagon_x],
      [-half_flat, -octagon_x],
      [-octagon_x, -half_flat],
      [octagon_x, -half_flat],
      [half_flat, -octagon_x],
    ]);
}

// One corner ear, standing off the +y chamfer face. Its full-reach tip is the
// face on the plate and it tapers away going up, so it cannot overhang
module corner_ear() {
  hull() {
    translate([-ear_base_width / 2, chamfer_face - eps, 0])
      cube([ear_base_width, eps, ear_height]);
    translate([-ear_tip_width / 2, chamfer_face + ear_reach - eps, 0])
      cube([ear_tip_width, eps, ear_tip_height]);
  }
}

// Half the plan outline of a nub on the +y face, from the buried root round to
// the middle of the tip. Points are [x, y] with y absolute
function nub_half_outline() =
  concat([
    [nub_base_width / 2, half_flat - eps]
  ], [
    for (i = [0:16])
      let (a = nub_arc_sweep * (1 - i / 16))
        [nub_arc_x + nub_tip_radius * sin(a), half_flat + nub_arc_reach + nub_tip_radius * cos(a)]
  ]);

// The nub is the plan outline crossed with a wedge that closes the nub's top
// and bottom in at nub_face_angle as it reaches out. Building it as an
// intersection keeps the two independent: the outline owns the tip rounding,
// the wedge owns the face angle, and neither can distort the other
module nub() {
  intersection() {
    translate([0, 0, -eps])
      linear_extrude(height = snap_thickness + 2 * eps)
        polygon(concat(nub_half_outline(), [
          for (i = [len(nub_half_outline()) - 1:-1:0])
            [-nub_half_outline()[i][0], nub_half_outline()[i][1]]
        ]));
    hull() {
      translate([-snap_across_flats, half_flat - 0.5, nub_centre_z - nub_height / 2])
        cube([2 * snap_across_flats, 0.5, nub_height]);
      translate([-snap_across_flats, half_flat + nub_reach - eps, nub_centre_z - nub_tip_height / 2])
        cube([2 * snap_across_flats, eps, nub_tip_height]);
    }
  }
}

// The slot that frees one arm to flex. It stops short of the front face and runs
// out through the front face, so it has no roof to bridge
module relief_slot() {
  translate([0, half_flat - slot_wall - slot_width / 2, slot_offset_to_front])
    hull() {
      for(s = [-1, 1])
        translate([s * (slot_length - slot_width) / 2, 0, 0])
          cylinder(d = slot_width, h = snap_thickness, $fn = 32);
    }
}

// The relief groove above each slot. Its roof is a gable rather than a flat
// bridge, the same trick the shelf tube anchor's tie channel uses: each slope
// runs half the groove's depth outward while rising the same half, so it is
// 45 deg whatever groove_depth is set to, and no value can turn it back into a
// ceiling. The mouth is untouched — the gable only lifts the hidden interior —
// so the face profile the board sees is still the openGrid standard.
//
// The outboard point rides the same 45 deg line rather than sitting square out
// from the face, which is why it drops by eps as well as stepping out by it.
// Extending it horizontally instead would leave that one facet at 45.7 deg:
// the eps is there to clear the face for a clean cut, and it has no business
// changing the angle it clears it at
module face_groove() {
  groove_top = groove_offset_to_front + groove_height;
  groove_peak = groove_depth / 2;
  rotate([0, 0, 90])
    rotate([90, 0, 0])
      linear_extrude(height = groove_length, center = true)
        polygon([
          [half_flat + eps, groove_offset_to_front],
          [half_flat - groove_depth, groove_offset_to_front],
          [half_flat - groove_depth, groove_top],
          [half_flat - groove_peak, groove_top + groove_peak],
          [half_flat + eps, groove_top - eps],
        ]);
}

module magnet_snap() {
  difference() {
    union() {
      body();
      for(a = [45:90:315])
        rotate([0, 0, a])
          corner_ear();
      for(a = [0:90:270])
        rotate([0, 0, a])
          nub();
    }
    for(a = [0:90:270])
      rotate([0, 0, a]) {
        relief_slot();
        face_groove();
      }
    translate([0, 0, bore_floor])
      cylinder(d = bore_d, h = bore_depth + eps);
    if (through_hole)
      translate([0, 0, -eps])
        cylinder(d = through_hole_d, h = snap_thickness + 2 * eps);
  }
}

magnet_snap();
