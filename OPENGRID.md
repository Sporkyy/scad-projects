# openGrid notes

Reference for building openGrid parts in this repository. It exists because
openGrid's dimensions are not published as a table anywhere — they live inside
the models — and because several plausible-looking assumptions about the system
turn out to be wrong. Everything here was either measured off a mesh or stated
by someone who owns the tiles.

This file is about the **system**, not about any one part, so it stays at the
top level rather than in a part's directory. Parts link back to it.

## The system

28 mm grid pitch, chosen to be Gridfinity-compatible. Tiles come in several
thicknesses and the thickness decides what snaps fit:

| Tile | Thickness | Takes |
| --- | --- | --- |
| Lite | 4 mm | Lite snaps, 3.4 mm, one face |
| Regular ("Full") | 6.8 mm | A full snap, 6.8 mm, filling the tile |
| Heavy | 13.6 mm | **A full 6.8 mm snap in each face** |
| Hybrid | mixed | Regular over most of its area, thicker at one edge |

**A Heavy tile is twice a regular one, not the same as one.** It is built to be
loaded from both sides, which is why it is described as having two fronts and no
back: each snap presents its ears outward and the two shanks meet in the middle.
A Heavy cell fitted from one side only is still half empty from the other. The
13.6 mm figure comes from the tile itself rather than from any snap library —
snap generators only ever know about snap thicknesses.

Lite snaps are not simply thinner full snaps. The nub heights change too
(2 mm becomes 1.8 mm on the basic nub, 4 mm becomes 2.4 mm on the directional
one), so a lite version of a part is a real port, not a one-line change.

## Front and back on a snap

Every feature a full snap has sits in its first 3.4 mm — the four corner ears at
the face itself, the face nubs just behind them. The remaining 3.4 mm is plain
shank.

The **shank is what goes into the tile**. So:

- **Front** = the wide end, carrying the ears. Stays on the side you pushed from
  and faces you. Measured on the mesh it reaches **15.40 mm** from the axis.
- **Back** = the narrow end of the shank, running away from you toward whatever
  the tile is mounted on. Reaches **14.53 mm**.

These are properties of the snap, not of the tile or the wall, so they do not
swap meaning depending on who is holding it. Name variants with them.

## Full snap profile

Reproduced from [mitufy's parametric snap
generator](https://github.com/mitufy/opengrid-projects), which is a recreation
of David D's official snaps. These are the symmetric full-snap numbers, all in
mm, with the front face as the datum:

| Feature | Value |
| --- | --- |
| Thickness | 6.8 |
| Body across flats | 24.8 |
| Corner chamfer leg | `2.7 * sqrt(2) + 1` = 4.81838 |
| Octagon vertices | (±12.4, ±7.5816) |
| Chamfer face radius | 14.1291 |
| Ear height / reach / tip height | 1.5 / 1.1 / 0.4 |
| Ear width at chamfer face | `chamfer * sqrt(2)` = 6.8137 |
| Nub height / reach | 2 / 0.4 |
| Nub width, base → tip | 10.8 → 6.8 |
| Nub face angle | 35° from vertical |
| Nub offset from front face | 1.4 |
| Nub tip rounding | r15 arc, tangent to the tip face at ±1.9147 and to the side at (0.1087, ±4.8568) |
| Relief slot | 12.4 long × 0.6 wide, 0.7 wall outboard, stops 0.6 from the front face |
| Face groove | 12.4 long × 0.8 deep × 0.4 tall, 0.8 from the front face |

The ear underside and the ear's side tapers are all 45°: the ear reaches
`ear_reach` outward while rising `ear_height - ear_tip_height`, and those two are
equal. Write them from one expression so the angle cannot drift.

The nub is best built as an intersection of its plan outline with a wedge that
closes the top and bottom in at 35°. That keeps the tip rounding and the face
angle independent, so neither distorts the other.

## Licensing

openGrid's core parts are released **CC-BY**, which is the practical reason to
prefer it over Multiboard: Multiboard uses a custom non-commercial licence that
restricts remixes and paid derivatives, while anyone can remix, sell, or build on
openGrid with attribution. That difference is why the openGrid accessory
ecosystem has grown faster.

- openGrid by David D — [opengrid.world](https://www.opengrid.world),
  [Printables](https://www.printables.com/model/1214361-opengrid-walldesk-mounting-framework-and-ecosystem),
  [GitHub](https://github.com/openGrid-3D)
- mitufy's snap generator — [GitHub](https://github.com/mitufy/opengrid-projects),
  CC BY 4.0

Attribution is a condition, not a courtesy. Any part here that reproduces the
snap profile names both in its header.

## Printing openGrid snaps

Three rules, in priority order:

1. **A magnet or fastener bore must open upward.** A 10 mm circular ceiling is a
   real bridge and is not worth accepting.
2. **The relief slots open out of the back face.** Print front-face-down and they
   have no roof at all. This is free whenever nothing on the front face needs to
   open up.
3. **The face groove has a flat roof in the official profile, whichever way up
   you print it.** Replace it with a 45° gable. The gable stays entirely inboard
   of the face plane, so the groove's mouth is unchanged and a tile cannot tell
   the difference; it costs about 2 mm³ per arm root out of a pocket that exists
   to be empty.

When rules 1 and 2 conflict — a bore on the front face — rule 1 wins and the
slots end up with roofs. **Leave those roofs flat.** They span the slot's 0.6 mm
width, not its 12.4 mm length, which is a gap no support material could occupy.
Every way of angling one is taken out of the 0.6 mm of material above the slot,
and that material is the root the arm hinges on: a 45° gable halves it to 0.3 mm,
under a single 0.42 mm perimeter, and a ramp across the slot consumes it outright
and opens a slit to the front face. The snap fit lives in that hinge and a 0.6 mm
bridge does not.

## Verifying a reimplementation

Every `.scad` here is self-contained, so the snap profile has to be rewritten
rather than included. Check the rewrite against the generator rather than by eye:

```sh
git clone --depth 1 https://github.com/BelfrySCAD/BOSL2.git libraries/BOSL2
curl -sLO https://raw.githubusercontent.com/mitufy/opengrid-projects/main/opengrid_parametric_snap.scad
mkdir lib && cd lib && for f in opengrid_base opengrid_snap_lib openconnect_lib opengrid_threads_lib; do
  curl -sLO "https://raw.githubusercontent.com/mitufy/opengrid-projects/main/lib/$f.scad"; done

OPENSCADPATH=$PWD/libraries /Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD \
  -o ref.stl --export-format binstl \
  -D 'generate_snap="Bare"' -D 'snap_body_shape="Symmetric"' \
  -D 'thickness_text_mode="None"' -D 'uninstall_notch_width=0' \
  opengrid_parametric_snap.scad
```

Then boolean-difference your part against `ref.stl` both ways and compare
volumes. **Expect agreement to about 0.02%.** The residue is the generator's own
`EPS = 0.005` shiftout, which sinks each feature 0.005 mm into the body to
guarantee a clean union — it shows up as a thin skin over every nub and ear, and
your clean nominal geometry is arguably the more correct of the two.

The generator's individual features can be isolated for study with
`disable_snap_corners`, `disable_snap_nubs`, `disable_snap_cuts` and
`uninstall_notch_width=0`, which is how the numbers in the table above were
recovered.

## Things that looked true and were not

Recorded because each one cost a rebuild, and each is easy to re-derive wrongly.

- **A Heavy tile is not 6.8 mm.** 3.4 + 3.4 happening to equal 6.8 makes a tidy
  story about two Lite snaps meeting in the middle. It is wrong. Heavy is 13.6
  and takes two *full* snaps.
- **The ears do not go into the tile.** The shank does. So the ear face stays on
  the side you inserted from, which reverses any rule about which variant to
  pick for a given mounting.
- **The slot roofs span 0.6 mm, not 12.4 mm.** The slot is 12.4 long and 0.6
  wide; the bridge distance is the width. Getting this backwards makes an
  acceptable feature look unacceptable and vice versa.
- **The official snap is not overhang-clean.** Its face grooves have flat 90°
  roofs whichever way up it prints. Do not assume a published, widely printed
  part passes a 45° check.
- **`scripts/overhangs.py` calls anything at absolute z ≤ 1e-3 the build plate.**
  A mesh flipped with `rotate([180,0,0])` and not translated back to z = 0 sits
  at negative z, and every downward facet reads as first layer — so the script
  reports a clean part that is not. Always translate a flipped mesh back onto the
  plate before analysing it.
