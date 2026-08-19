// ============================================================
// Turn-N-Tube shelf coupler — rigid lozenge collar
// Connects two adjacent shelf units at one tube height.
// Replaces zip ties: wraps both tube posts, with a fin on the
// underside that keys into the gap between the two units'
// edges (perpendicular to the tube-to-tube line) to resist
// rotation. Relies on gravity pressing down onto the shelf
// below, so the fin only needs to be on the bottom face per
// shelf level. Expect the fin to wedge the two units apart
// slightly (by roughly fin_width) versus how they sit now.
//
// PRINT NOTES:
// - PETG, no supports needed (holes are round, drop wall is
//   solid down to a flat bottom).
// - Print with the collar axis vertical (as modeled) so the
//   holes print round and the tube slides through cleanly.
// - You'll want 2 of these per shelf level (one per photo's
//   "figure 8" pair), 8 total for the 5-tier unit in the photo
//   (top shelf has no tube, so no coupler there).
// ============================================================

// ===== MEASURE THESE ON YOUR ACTUAL SHELVES =====
tube_od         = 25;   // outer diameter of the vertical tube post (mm) — MEASURE, these vary
center_distance = 150;  // center-to-center distance between the left and right tube posts (mm)
                         // NOTE: this may differ slightly shelf-to-shelf if the unit tapers —
                         // measure per shelf level and make one variant per size if needed

// ===== TUNE THESE =====
hole_clearance    = 0.6;  // added to hole diameter for slip fit (mm) — increase if too tight
wall_meat         = 7;    // PETG thickness around each hole (mm)
collar_height     = 18;   // height of the main collar at the shelf level (mm)
drop_wall_height  = 25;   // how far the fin drops below the collar to key into the gap below (mm)

// The fin runs perpendicular to the tube-to-tube line (X axis), so it
// slots into the gap between the two shelf units' edges instead of
// running parallel to it. This will wedge the two units apart slightly
// by roughly fin_width — that's expected.
fin_width  = 8;   // thickness of the fin along X (the left-right gap it wedges into), mm
fin_depth  = 40;  // length of the fin along Y (front-to-back), mm — how deep it keys in

$fn = 100;

hole_r   = tube_od/2 + hole_clearance/2;
collar_r = hole_r + wall_meat;

// 2D lozenge (stadium) shape: hull of two circles
module lozenge_2d(r, cdist) {
    hull() {
        translate([-cdist/2, 0]) circle(r = r);
        translate([ cdist/2, 0]) circle(r = r);
    }
}

module coupler() {
    difference() {
        union() {
            // main collar at shelf height
            linear_extrude(height = collar_height)
                lozenge_2d(collar_r, center_distance);

            // anti-rotation fin, bottom face only, centered in the
            // waist of the lozenge (where the collar is a full 2*collar_r
            // wide, so the fin sits flush underneath with no overhang)
            translate([0, 0, -drop_wall_height])
                linear_extrude(height = drop_wall_height)
                    square([fin_width, fin_depth], center = true);
        }

        // through-holes for the two tube posts
        translate([-center_distance/2, 0, -drop_wall_height - 1])
            cylinder(r = hole_r, h = collar_height + drop_wall_height + 2);
        translate([ center_distance/2, 0, -drop_wall_height - 1])
            cylinder(r = hole_r, h = collar_height + drop_wall_height + 2);
    }
}

coupler();
