// SPDX-License-Identifier: CC-BY-4.0
// SPDX-FileCopyrightText: 2026 Todd Sayre
// ============================================================
// Sailor hat — a wearable Dixie cup with inlaid initials
//
// The US Navy enlisted white hat, as worn by a certain retro
// bear mascot: a shallow bucket with a turned-up brim, two
// initials set into the band. It is one printed shell plus two
// separate letter tiles that drop into pockets cut for them, so
// the lettering comes out a different colour without a filament
// swap, an AMS, or any purge waste.
//
// The letters are a system with the pockets rather than parts
// in their own right. They share every dimension that decides
// whether they seat, so they live in this one source and export
// as three bodies, the way the dogbone's halves do.
//
// THE ONE MEASUREMENT IS A CIRCUMFERENCE, AND IT BREAKS THIS
// REPOSITORY'S CALIPER RULE ON PURPOSE. A head is about 185 mm
// across, past a 12 in caliper, and there is nothing on a head
// for jaws to close on anyway. Headwear has been sized by a
// flexible tape around the skull for as long as there has been
// headwear, and that is the instrument this parameter names.
// The rule exists so a value that needed the wrong tool gets
// caught; here the right tool is simply not a caliper. Diameter
// is then derived, never measured, exactly as the rule intends.
//
// EVERYTHING ELSE FALLS OUT OF THAT ONE NUMBER. The crown is
// the head plus a wall, the brim is the crown plus its stand-
// off, and the outside diameter is whatever those come to. No
// outer dimension is set directly.
//
// Modeled in its print orientation: flat top on the plate,
// mouth up. The cavity then opens upward and has no roof to
// bridge — the alternative is a flat ceiling the full 185 mm
// across the head, which is not a bridge anyone should attempt.
// Every outward flare on the way up is 45 deg by construction:
// the top chamfer rises by its own run, and the brim flares out
// by exactly brim_proud while rising the same, so no value of
// either can turn one into an overhang.
//
// THE LETTERING IS THE ONLY THING THAT HANGS, AND NONE OF IT
// REACHES FURTHER THAN letter_depth. Two features do it. The
// material above a letter cantilevers out over its pocket, a
// flat ceiling whose span is the pocket's depth rather than the
// letter's width — the same overhang any screw hole through a
// vertical wall has. And a letter with a closed counter leaves
// an island of wall standing inside it: the U's bowl, and O, D
// or P if you change the initials. That island's underside
// follows the inside of the glyph, so it sweeps from vertical
// round to horizontal at the bottom of the counter.
//
// Both are cantilevers standing off the pocket floor, so their
// reach is letter_depth however steep the angle gets. Drafting
// them away would mean tapering the pocket along a letter
// outline, which stops the inlay seating flush, and a flush
// inlay is the entire point of the part. Shallower pockets buy
// a shorter reach if it ever matters.
//
// PRINT NOTES:
// - PLA or PETG for the shell. Print as modeled, flat top down.
//   Do not let the slicer turn it over.
// - The shell is a big thin bucket. 3 walls, 10% infill, and no
//   supports. It is all vertical or 45 deg.
// - The flat top is the first layer and it is a wide disc, so
//   adhesion is easy. The rim at the far end is the free edge
//   and is where any warp will show.
// - The two letter tiles are small and slightly curved, about
//   half a millimetre across their width. Give them a brim.
// - Letters go in after printing. The pocket is cut letter_fit
//   larger all round, so they should drop in and want a dab of
//   glue rather than a press. The tiles are curved on the show
//   face and flat on the back, which is both what lets them sit
//   flush in a round brim and what gives them a face to print
//   on.
// - This is a costume piece, not PPE. It is a rigid shell and
//   it will crack rather than deform if it is sat on.
// ============================================================

// ===== MEASURE THIS ON THE ACTUAL HEAD =====
// This one is a tape measurement, not a caliper one — see the note above.
// Run a flexible tape around the head at its widest, just above the ears and
// across the brow, snug but not pulled in. Read it in millimetres. Adult heads
// run about 540 to 620 mm; 580 is a common middle
head_circumference = 580;

// ===== TUNING KNOBS =====

// Diametral slack between head and crown (mm). This is the whole difference
// between a hat that drops on and one that grips. It is a diameter, so half of
// it shows up as gap on each side
head_clearance = 6;

crown_wall = 2.5; // Wall thickness around the crown (mm)
top_wall = 2.5; // Material over the top of the head (mm)

// Wall thickness of the brim cuff (mm). The brim is hollow, not a solid ring —
// filled solid it would be most of the hat's weight and print time on its own.
// It is thicker than the crown because the letter pockets are cut into it
brim_wall = 5;

// How far the brim band stands out past the crown (mm). It sets the brim's
// presence, and because the flare below it rises by this same amount the
// flare is 45 deg whatever value is chosen
brim_proud = 7;

crown_h = 40; // Height of the vertical crown wall (mm)
brim_h = 28; // Height of the vertical brim band, which is what carries the letters (mm)

// Chamfer taking the flat top out to the crown wall (mm). Rises by its own run,
// so it is always 45 deg. Bounded by the material available above the head —
// see the assertion below
top_chamfer = 4;

rim_chamfer = 1.5; // Breaks the outer edge of the rim (mm)

// ===== LETTERING =====

letter_left = "M";
letter_right = "U";

// Font. Liberation Sans ships with OpenSCAD, so this file renders anywhere.
// The mascot's lettering is a blocky collegiate slab; swap this for one you
// have if you want to chase it
letter_font = "Liberation Sans:style=Bold";

letter_size = 20; // Nominal font size (mm)

// Height of a capital in the chosen font (mm). OpenSCAD's size is an ascent
// rather than an em, so for Liberation Sans Bold a capital lands near 0.95 of
// it. This is the number the letters are centred and checked against, so if you
// change fonts, measure a render and put the answer here
letter_cap_height = 19;

letter_edge_margin = 3; // Band left clear above and below the lettering (mm)
letter_depth = 2; // Deepest point of the pocket, and the thickest point of a tile (mm)

// Clearance around each tile (mm), applied to the pocket rather than the tile,
// so the letters stay the size they were drawn and the hole grows instead
letter_fit = 0.25;

letter_pitch = 30; // Centre-to-centre spacing of the two letters (mm)

// Where the lettering sits around the hat (degrees). Cosmetic on the part —
// the wearer decides which way is front by how they put it on — but it is what
// turns the initials towards the catalogue preview's fixed camera
letter_azimuth = 205;

// Backing left behind a pocket (mm). Asserted, not merely hoped for
letter_backing_min = 1.2;

// ===== PRINTER =====

bed_size = 256; // Print bed, short side (mm)
bed_margin = 6; // Clearance at each bed edge for brim and skirt (mm)
part_gap = 10; // Separation between the exported bodies (mm)

// ===== DERIVED =====

head_d = head_circumference / PI; // Never measured — derived from the tape
r_head = (head_d + head_clearance) / 2;
r_crown = r_head + crown_wall;
r_brim = r_crown + brim_proud;
r_brim_in = r_brim - brim_wall;
r_top = r_crown - top_chamfer;

// The cuff's inside is wider than the crown's, so the cavity opens out on the
// way up. Run equals rise, so this taper is 45 deg however the walls are set —
// and it is a widening cavity, which cannot hang whatever angle it takes
inner_taper = r_brim_in - r_head;

z1 = top_chamfer; // Top chamfer meets the crown wall
z2 = z1 + crown_h; // Crown wall meets the brim flare
z3 = z2 + brim_proud; // Brim flare meets the band — 45 deg, rise equals brim_proud
z4 = z3 + brim_h; // The rim, and the mouth

hat_od = 2 * r_brim;
brim_mid_z = z3 + brim_h / 2;

// Where a pocket floor sits: a plane this far in from the brim's outer surface.
// Flat, not curved, so the tile that fills it has a flat back to print on
r_pocket_floor = r_brim - letter_depth;

$fa = 1;
$fs = 0.6;
eps = 0.01;

// ===== SANITY CHECKS =====

assert(hat_od <= bed_size - 2 * bed_margin, "Hat is wider than the bed — measure again or print it on something larger");

// The top chamfer eats inward from the crown while the flat top sits at
// top_wall above the cavity floor. Let it run past what the walls provide and
// the chamfer undercuts the cavity, which makes the cross-section cross itself
assert(top_chamfer <= crown_wall + top_wall, "top_chamfer is deeper than crown_wall plus top_wall — the top would undercut the cavity");

assert(inner_taper > 0, "brim_wall is thicker than the brim stands proud — the cuff would pinch in past the crown");
assert(z3 - inner_taper > top_wall, "The cuff's inner taper reaches below the crown top");
assert(letter_depth <= brim_wall - letter_backing_min, "Letter pockets leave less than letter_backing_min behind them");
assert(rim_chamfer < brim_wall, "Rim chamfer is wider than the cuff wall");
assert(letter_cap_height + 2 * letter_edge_margin <= brim_h, "Lettering does not leave letter_edge_margin above and below it on the band");
assert(head_clearance > 0, "A hat with no clearance is a hat that does not go on");

echo(str("Head: ", head_circumference, " mm around, so ", head_d, " mm across"));
echo(str("Hat: ", hat_od, " mm outside diameter, ", z4, " mm tall"));
echo(str("Bed needed: ", hat_od + 2 * bed_margin, " mm of ", bed_size));
echo(str("Brim cuff: ", brim_h, " mm tall, ", brim_wall, " mm wall, pockets ", letter_depth, " mm deep leaving ", brim_wall - letter_depth, " mm behind"));
echo(str("Lettering: ", letter_cap_height, " mm caps on a ", brim_h, " mm band, ", (brim_h - letter_cap_height) / 2, " mm clear above and below"));
echo(str("Overhangs: 45 deg on the shell; the lettering reaches up to 90 deg but never further out than ", letter_depth, " mm"));

// ===== GEOMETRY =====
// Modeled in its print orientation: flat top on the plate at z = 0, mouth up

// The whole shell is one revolved cross-section. Written as a closed loop out
// along the top face, up the outside, over the rim and back down the inside,
// so every wall thickness is whatever the two paths leave between them
module shell() {
  rotate_extrude()
    polygon([
      [0, 0],
      [r_top, 0],
      [r_crown, z1],
      [r_crown, z2],
      [r_brim, z3],
      [r_brim, z4 - rim_chamfer],
      [r_brim - rim_chamfer, z4],
      [r_brim_in, z4],
      [r_brim_in, z3],
      [r_head, z3 - inner_taper],
      [r_head, top_wall],
      [0, top_wall],
    ]);
}

// One glyph as a slab standing in the brim band, facing out along +y and cut
// off at the pocket floor. Bounding it by the brim cylinder afterwards curves
// the outer face to the hat; the inner face stays the flat plane this leaves,
// which is what gives the tile something to print on.
//
// THE GLYPH IS MIRRORED VERTICALLY, AND HAS TO BE. This file is modeled in its
// print orientation, which is upside down from how the hat is worn — going
// from one to the other is a half turn about a horizontal axis, and that
// negates z while leaving x alone. A letter drawn upright here would therefore
// read upside down on a head. Mirroring in y only, before the extrusion, is
// what cancels it: turning the glyph a half turn instead would negate x too
// and leave the initials running backwards. Both letters and pockets come
// through this one module, so they cannot disagree about which way up they are
module glyph_slab(ch, dx, grow, depth) {
  translate([dx, r_brim + eps, brim_mid_z])
    rotate([90, 0, 0])
      linear_extrude(height = depth + eps)
        mirror([0, 1, 0])
          offset(r = grow)
            translate([0, -letter_cap_height / 2])
              text(ch, size = letter_size, font = letter_font, halign = "center", valign = "baseline");
}

// A letter tile: curved on its show face, flat on its back
module letter(ch, dx) {
  intersection() {
    glyph_slab(ch, dx, 0, letter_depth);
    cylinder(r = r_brim, h = z4);
  }
}

// Its pocket: the same glyph grown by the fit, cut a hair deeper so a tile
// cannot bottom out before its face is flush
module letter_pocket(ch, dx) {
  intersection() {
    glyph_slab(ch, dx, letter_fit, letter_depth + eps);
    cylinder(r = r_brim + eps, h = z4);
  }
}

module hat() {
  difference() {
    shell();
    rotate([0, 0, letter_azimuth]) {
      letter_pocket(letter_left, -letter_pitch / 2);
      letter_pocket(letter_right, letter_pitch / 2);
    }
  }
}

// A tile laid down on its flat back, which is the only face either tile has
// that a bed would accept
module letter_flat(ch, dx) {
  rotate([90, 0, 0])
    translate([-dx, -r_pocket_floor, -brim_mid_z])
      letter(ch, dx);
}

hat();

translate([0, r_brim + part_gap + letter_size, 0]) {
  translate([-letter_pitch / 2, 0, 0])
    letter_flat(letter_left, -letter_pitch / 2);
  translate([letter_pitch / 2, 0, 0])
    letter_flat(letter_right, letter_pitch / 2);
}
