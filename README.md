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

The body is a lozenge that slips over both vertical tube posts. A fin on the
underside drops into the gap between the two units' facing shelf edges, running
perpendicular to the tube-to-tube line so it resists the units twisting apart.
It rests on the shelf below, so one coupler per level only needs the fin on its
bottom face.

The fin is wider than the gap it drops into, so it **wedges the two units apart**
as it seats. The hole spacing is derived for that final wedged-apart position
rather than the spacing you measure beforehand — otherwise the holes miss the
tubes by several millimetres and the part won't go on.

**Measuring.** Set `spacing_mode` to match how you got at the tubes:

| Mode | Measure | Use when |
| --- | --- | --- |
| `"gap"` | `tube_gap` — inside jaws across the clear space between the two posts | Default; calipers fit between the tubes |
| `"edges"` | `left_tube_to_edge` / `right_tube_to_edge` — each tube's outer surface out to its own shelf's facing edge | Calipers won't fit between the tubes, or the tubes sit differently on each unit |

Both modes also need `shelf_edge_gap`, the clear space between the two units'
shelf edges as they currently sit (`0` if touching). That is the slot the fin
keys into, and it sets how far the units get pushed apart.

`"edges"` mode also offsets the fin, since an asymmetric pair puts the slot off
the collar's centreline.

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
/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD -o out.stl -D 'tube_gap=12' shelf_tube_coupler.scad
```

A failed assertion means the numbers don't make a printable part, not that
something is broken — shrinking `tube_od` far enough, for instance, pulls the
collar in narrower than `fin_depth` and the fin would overhang. Adjust the
flagged parameter and re-render.

Source is formatted with [scadformat](https://github.com/hugheaves/scadformat).
It leaves a `.scadbak` beside each file it touches; the *Clean .scadbak backups*
VS Code task clears them.

Exported `.stl` and `.3mf` files are build output and are not tracked — render
your own from source.

## License

MIT — see [LICENSE](LICENSE).
