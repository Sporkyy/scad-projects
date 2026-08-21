# scad-projects

Parametric OpenSCAD models for 3D-printed parts, mostly one-off fixes for
things around the house. Each project is a single self-contained `.scad` file
at the repo root, with its measured dimensions as variables at the top.

Every model is written to be measured with **calipers**. Parameters are always
things a caliper can physically reach — outside diameters, clear gaps,
edge-to-edge spans — never a center-to-center distance or a dimension inside a
hollow part. Anything like that gets derived instead.

## Projects

### Shelf tube coupler — [`shelf_tube_coupler.scad`](shelf_tube_coupler.scad)

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
knob — how far it drops. Its thickness is `shelf_gap` exactly, and its
front-to-back depth is the collar's own, so it runs flush with the collar sides.

Spacing can drift between levels if the unit tapers, so measure per shelf and
build a variant per size if they differ.

**Printing.** PETG, no supports. Print collar-axis vertical as modelled so the
holes come out round and the tube slides through. Budget two per shelf level —
eight for a five-tier unit, since the top shelf has no tube above it.

## Working with these

Render a mesh:

```sh
/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD -o out.stl shelf_tube_coupler.scad
```

Each model `echo`s its derived dimensions and `assert`s against interferences,
so check the console output against the real part before committing to a print.
Try a variant without editing the file using `-D`:

```sh
/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD -o out.stl -D 'shelf_gap=12' shelf_tube_coupler.scad
```

A failed assertion means the numbers don't make a printable part, not that
something is broken — asking for a wall with `shelf_gap = 0`, for instance,
leaves it nothing to fill. Adjust the flagged parameter and re-render.

Source is formatted with [scadformat](https://github.com/hugheaves/scadformat).
It leaves a `.scadbak` beside each file it touches; the *Clean .scadbak backups*
VS Code task clears them.

Exported `.stl` and `.3mf` files are build output and are not tracked — render
your own from source.

## License

MIT — see [LICENSE](LICENSE).
