// ============================================================
// Dowel end cap — a blind socket that closes off a dowel end
//
// A plain cylinder with a cylindrical recess bored into one
// end. The dowel pushes into the recess until it bottoms out;
// the remaining material caps the end.
//
// Modeled mouth up, closed end on the plate.
//
// The cap DEFINES its own proportions from one measurement.
// Everything is driven by the dowel diameter plus the meat you
// want around it, so the outside diameter and the overall
// length both fall out of the numbers below rather than being
// set directly.
//
// The recess is a dimension inside a hollow solid, so it is
// never measured — it is bored to the dowel diameter plus a
// clearance knob. Measure the dowel, not the hole you want.
//
// PRINT NOTES:
// - PETG or PLA, no supports needed.
// - Print as modeled, closed end down. The bore opens upward,
//   so nothing bridges, and the visible end face is laid
//   against the plate. Flipped, the bore roof has to bridge
//   its full width — it works, but it leaves a rough ceiling
//   for the dowel to bottom out against.
// - The bore prints round with the axis vertical either way.
// - Chamfers break both rims and take the elephant foot off
//   whichever end lands on the plate.
// ============================================================

// ===== MEASURE THIS ON YOUR ACTUAL DOWEL =====
// An outside-the-solid measurement, so plain calipers reach it. It names the
// caliper it needs by the size printed on the tool: a 6 in caliper stops at
// 150 mm, an 8 in at 200 mm, a 12 in at 300 mm

// Outer diameter of the dowel (mm) — outside jaws on the dowel, 6 in caliper.
// Take it in two or three places and around a couple of rotations: wooden
// dowel is rarely round and rarely the size on the label. Use the largest
// reading, since that is the one that has to fit
dowel_d = 12;

// ===== DECIDE THESE =====
// Choices, not measurements — the cap is whatever these make it

// How far the dowel goes into the cap (mm). Deeper grips better and resists
// being levered off sideways; about 1.5 dowel diameters is plenty
penetration_depth = 18;

// Thickness of material around the dowel (mm). Sets the outside diameter and
// the thickness capping the end, both at once
wall_meat = 3;

// ===== TUNE THESE =====
dowel_clearance = 0.3; // Added to the bored diameter for a glue or friction fit (mm) — raise if it will not seat, drop toward 0 for a tighter press
chamfer = 1; // Break on both outer rims (mm)
lead_in = 0.6; // Funnel at the mouth of the bore, to start the dowel square (mm)

$fn = 100;

// ===== DERIVED =====
bore_d = dowel_d + dowel_clearance;
cap_d = dowel_d + 2 * wall_meat;
cap_length = penetration_depth + wall_meat;

// Material left on the face of the rim, once the outer chamfer has taken from
// the outside and the lead-in funnel has taken from the inside. The cap is
// only as strong at the mouth as this, and it is the first thing a large
// chamfer or a generous lead-in eats
rim_face = (cap_d - bore_d) / 2 - chamfer - lead_in;

echo(str("outside diameter = ", cap_d, " mm"));
echo(str("overall length = ", cap_length, " mm"));
echo(str("bored diameter = ", bore_d, " mm"));
echo(str("rim face at the mouth = ", rim_face, " mm"));

assert(wall_meat > 0, "wall_meat has to be positive — there is no cap without material around the dowel");
assert(penetration_depth > 0, "penetration_depth has to be positive — the dowel has to go somewhere");
assert(bore_d > 0, "dowel_clearance has closed the bore — it cannot be more negative than the dowel is wide");
assert(rim_face > 0, "the mouth has no rim left — reduce chamfer or lead_in, or add wall_meat");
assert(chamfer < cap_length / 2, "the two outer chamfers have met in the middle — reduce chamfer");
assert(lead_in < penetration_depth, "the lead-in funnel is deeper than the bore — reduce lead_in");

// Outer silhouette, revolved: a cylinder with both rims broken. x is radius
// out from the axis, y is height up from the closed end
module cap_body() {
  r = cap_d / 2;
  rotate_extrude()
    polygon([
      [0, 0],
      [r - chamfer, 0],
      [r, chamfer],
      [r, cap_length - chamfer],
      [r - chamfer, cap_length],
      [0, cap_length],
    ]);
}

module dowel_endcap() {
  difference() {
    cap_body();

    // Blind bore for the dowel, opening upward at the mouth
    translate([0, 0, wall_meat])
      cylinder(d = bore_d, h = penetration_depth + 1);

    // Funnel at the mouth, so the dowel starts square instead of
    // catching on the rim
    translate([0, 0, cap_length - lead_in])
      cylinder(d1 = bore_d, d2 = bore_d + 2 * lead_in, h = lead_in);
  }
}

dowel_endcap();
