# scad-projects

Parametric OpenSCAD models for 3D-printed parts, mostly one-off fixes for
things around the house. Each project has its own directory, holding a
self-contained `.scad` source with its `.stl` and preview image beside it.
Measured dimensions are variables at the top of the source.

Every model is written to be measured with **calipers**. Parameters are always
things a caliper can physically reach — outside diameters, clear gaps,
edge-to-edge spans — never a center-to-center distance or a dimension inside a
hollow part. Anything like that gets derived instead.

## Projects

### Shelf tube coupler

[![Shelf tube coupler preview](shelf_tube_coupler/shelf_tube_coupler.png)](shelf_tube_coupler/shelf_tube_coupler.stl)

[View or download STL](shelf_tube_coupler/shelf_tube_coupler.stl) · [OpenSCAD source](shelf_tube_coupler/shelf_tube_coupler.scad)

A rigid collar that ties two adjacent Turn-N-Tube wire shelf units together at
one tube height, replacing zip ties.

The body is a lozenge that slips over both vertical tube posts, holding them a
fixed distance apart. It rests on the shelf below and carries no other features
— what it does is hold the spacing, and it does not hold the units square. The
brace below is what does that.

The coupler **defines** the spacing rather than fitting it. Nothing depends on
how far apart the units happen to sit today, so there is no need to get calipers
between the tubes at all.

**Measuring.** Two measurements, both reachable from outside:

| Parameter | Measure |
| --- | --- |
| `tube_od` | Outside jaws on a vertical tube post |
| `tube_to_edge` | A tube's outer surface out to the facing edge of its own shelf |

Override `left_tube_to_edge` / `right_tube_to_edge` if the two units differ —
a shelf that overhangs further on one side, or a post not set the same distance
in.

**Deciding.** `shelf_gap` is the gap you want between the two units' facing
shelf edges, and the hole spacing follows from it. A gap is worth having:
adjacent units rarely have their shelves at matching heights, and a deliberate
gap keeps that mismatch from reading as a misalignment.

Earlier versions could hang a wall below the collar to fill that gap. It is
gone. It was sold as resisting twist and it does not — see the brace below for
why no arrangement of couplers can — and covering the gap was never worth a
part that also had to fit into it. Nothing replaces it: the gap stays open, and
small items can drop through.

Spacing can drift between levels if the unit tapers, so measure per shelf and
build a variant per size if they differ.

**Printing.** PETG, no supports. Print collar-axis vertical as modelled so the
holes come out round and the tube slides through. Budget two per shelf level —
eight for a five-tier unit, since the top shelf has no tube above it.

### Shelf tube brace

[![Shelf tube brace preview](shelf_tube_coupler/shelf_tube_brace.png)](shelf_tube_coupler/shelf_tube_brace.stl)

[View or download STL](shelf_tube_coupler/shelf_tube_brace.stl) · [OpenSCAD source](shelf_tube_coupler/shelf_tube_brace.scad)

The third link that makes a coupled pair of units rigid. It shares the coupler's
directory because the two are one system.

Couplers on their own do not hold the units still. Each is pinned at both ends by
a round tube in a round hole, so a pair of them makes a four-bar linkage: one
degree of freedom, whatever their stiffness and however far apart they sit. The
units stay parallel and shear sideways. More couplers do not help, because they
all run the same direction. The freedom is kinematic, which is why the coupler's
old gap-filling wall never closed it — friction was the only tool it had.

Two rigid bodies have three degrees of freedom in plan and each link removes one,
so three links lock them together. The brace is the third: a long flat bar
running diagonally from one unit's **front** post to the other unit's **back**
post, not parallel to the couplers and so removing what they leave behind.

Three links is the entire requirement, so **one brace makes the pair rigid** no
matter how many levels are coupled. Couplers elsewhere in the stack only add
stiffness.

**Measuring.** Three measurements, all reachable from outside:

| Parameter | Measure |
| --- | --- |
| `tube_od` | Outside jaws on a vertical tube post |
| `tube_to_edge` | A tube's outer surface out to the facing edge of its own shelf — must match what the couplers were printed with |
| `post_span` | Tape along the side of one unit, outer face of the front tube to outer face of the back tube |

`post_span` defaults to `shelf_depth - 2 * tube_to_edge`, which assumes the posts
are inset from the long edges by the same amount as from the short ones. Confirm
that before printing: the brace has no slot to take up error, and its hole
spacing tracks this number nearly one for one. If the two units differ or do not
sit flush at the front, skip both and set `brace_span` — the diagonal measured
straight off the assembled pair, one unit's front tube to the other's back tube,
outer face to outer face.

`hole_clearance` is deliberately looser here than on the coupler, buying
tolerance for a tape measurement at the cost of about half of it in residual
sway.

**Printing.** PETG, no supports, flat on the bed. Flat runs the perimeters along
the load path, where on edge would load the bar across its layers. It is long
enough that placement matters: the echoed bed placement gives the angle and the
square it needs, and turning it 45° costs far less bed than laying it square on.
`bed_size` and `bed_margin` drive an assertion, so a span too big for the printer
fails the render rather than the print. One per pair of units.

The dogbone below does the same job a different way. Prefer the brace when you
want one part and no hardware, and can measure carefully; prefer the dogbone
when you would rather not have the fit depend on a measurement at all.

### Shelf tube dogbone

[![Shelf tube dogbone preview](shelf_tube_dogbone/shelf_tube_dogbone.png)](shelf_tube_dogbone/shelf_tube_dogbone.stl)

[View or download STL](shelf_tube_dogbone/shelf_tube_dogbone.stl) · [OpenSCAD source](shelf_tube_dogbone/shelf_tube_dogbone.scad)

The same rigidity as the brace, reached by gripping all four posts at one level
instead of triangulating. A plate pinned to two posts on a unit cannot rotate
relative to it, so a plate holding two posts on each unit locks the pair
together.

Whole, that plate is about 275 mm long and will not fit a 256 mm bed, so it
prints as two halves that bolt together at mid-depth with two M4 bolts. Both
halves come out of one source and one `.stl`, because every dimension they share
has to match for them to assemble.

**Four round holes would not go on.** Four holes on four posts dictates the
front-to-back post spacing of both units simultaneously, and two units that
disagree would leave the plate bridging nothing. So the front pair locates and
the back pair are slots running front to back. The round holes fix position, the
slots absorb whatever the units disagree about, and rotation stays fully
constrained because each slot is elongated along the line to its own round hole.
Nothing is left to friction.

That is also why this one tolerates a rough measurement where the brace does
not. `slot_travel` is the whole tolerance budget, 30 mm by default, and the
render echoes the window of `post_span` it covers.

**Measuring.** The same three as the brace:

| Parameter | Measure |
| --- | --- |
| `tube_od` | Outside jaws on a vertical tube post |
| `tube_to_edge` | A tube's outer surface out to the facing edge of its own shelf — must match what the couplers were printed with |
| `post_span` | Tape along the side of one unit, outer face of the front tube to outer face of the back tube |

`post_span` only has to land inside the slot window, so the default derived from
`shelf_depth` is usually good enough to print on.

**Printing.** PETG, no supports. Both halves print flat with the lap face down —
the step down to the lap is a drop in height, not an overhang. The two bodies are
exported clear of each other; let the slicer arrange them. Assemble with two M4
bolts, the front half as printed and **the back half turned over**, so its lap
sits on top of the front's and the finished plate is one thickness throughout.
One dogbone makes a pair of units rigid, whatever the stack height.

## Working with these

Regenerate every tracked STL and preview image:

```sh
python3 scripts/build.py
```

The default VS Code build task, *Build all objects*, runs the same command. With
an OpenSCAD source active, *Build current object* rebuilds only that object. Set
`OPENSCAD` to the CLI executable path if the script cannot find the installation.

Each model `echo`s its derived dimensions and `assert`s against interferences,
so check the console output against the real part before committing to a print.
Try a variant without editing the file using `-D`:

```sh
/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD -o /tmp/shelf_tube_coupler.stl -D 'shelf_gap=12' shelf_tube_coupler/shelf_tube_coupler.scad
```

A failed assertion means the numbers don't make a printable part, not that
something is broken — a `post_span` measured between the posts instead of
across them, for instance, describes a brace shorter than its own tube. Adjust
the flagged parameter and re-render.

Source is formatted with [scadformat](https://github.com/hugheaves/scadformat).
It leaves a `.scadbak` beside each file it touches; the *Clean .scadbak backups*
VS Code task clears them.

The OpenSCAD source is canonical. Its generated binary STL and PNG preview are
tracked beside it so GitHub can display the object and offer the mesh for
download. Bambu Studio `.3mf` projects contain slicer preferences, stay ignored,
and are never generated or distributed by this project.

## License

MIT — see [LICENSE](LICENSE).
