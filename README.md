# scad-projects

Parametric OpenSCAD models for 3D-printed parts, mostly one-off fixes for
things around the house. Each project has its own directory containing a
self-contained `.scad` source, a printable `.stl`, and a preview image. Measured
dimensions are variables at the top of the source.

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
fixed distance apart. An optional wall on the underside hangs down into the gap
between the two units' facing shelf edges. It rests on the shelf below, so one
coupler per level only needs the wall on its bottom face.

The coupler **defines** the spacing rather than fitting it. Nothing depends on
how far apart the units happen to sit today, so there is no need to get calipers
between the tubes at all.

**Measuring.** Two measurements, both reachable from outside:

| Parameter | Measure |
| --- | --- |
| `tube_od` | Outside jaws on a vertical tube post |
| `tube_to_edge` | A tube's outer surface out to the facing edge of its own shelf |

Override `left_tube_to_edge` / `right_tube_to_edge` if the two units differ.
That also offsets the wall, since an asymmetric pair puts the gap off the
collar's centreline.

**Deciding.** `shelf_gap` is the gap you want between the two units' facing
shelf edges, and the hole spacing follows from it. A gap is worth having:
adjacent units rarely have their shelves at matching heights, and a deliberate
gap keeps that mismatch from reading as a misalignment.

The wall is not structural — the hole spacing alone holds the gap, and two
couplers per level already resist twist. It hides the gap and stops small items
dropping through. Set `wall = false` to leave it off. `wall_height` is the only
shape knob — how far it drops. Its nominal thickness is `shelf_gap`, reduced by
`wall_clearance` so it fits without binding. Its front-to-back depth is the
collar's own, so it runs flush with the collar sides.

Spacing can drift between levels if the unit tapers, so measure per shelf and
build a variant per size if they differ.

**Printing.** PETG, no supports. Print collar-axis vertical as modelled so the
holes come out round and the tube slides through. Budget two per shelf level —
eight for a five-tier unit, since the top shelf has no tube above it.

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
something is broken — asking for a wall with `shelf_gap = 0`, for instance,
leaves it nothing to fill. Adjust the flagged parameter and re-render.

Source is formatted with [scadformat](https://github.com/hugheaves/scadformat).
It leaves a `.scadbak` beside each file it touches; the *Clean .scadbak backups*
VS Code task clears them.

The OpenSCAD source is canonical. Its generated binary STL and PNG preview are
tracked beside it so GitHub can display the object and offer the mesh for
download. Bambu Studio `.3mf` projects contain slicer preferences, stay ignored,
and are never generated or distributed by this project.

## License

MIT — see [LICENSE](LICENSE).
