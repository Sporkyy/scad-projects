# AGENTS.md

OpenSCAD source for 3D-printable parts. Each project has its own directory,
holding a `.scad` file per printable part alongside that part's generated `.stl`
and `.png` distribution files. Parts that are printed and used together belong in
one directory; a part that stands alone gets its own. Measured dimensions are
top-level variables in the source.

Every `.scad` stays self-contained — no `include` or `use` across files, even
between parts sitting in the same directory. Duplicate the handful of lines
instead. Each source is meant to be downloaded on its own and render.

## Formatting

Run `scadformat` on every `.scad` file you touch, after the edit. Do not
hand-format OpenSCAD — no manual alignment of `=`, no reflowing argument lists,
no adjusting indentation by eye. The formatter owns all of that.

```sh
scadformat path/to/file.scad   # Formats in place
```

It also reads stdin and writes stdout if you need a diff without touching the
file. Installed at `~/.local/bin/scadformat` (v0.10, not managed by Homebrew);
use that absolute path if it isn't on `$PATH`.

Every run drops a timestamped `.scadbak` backup beside the file, with no flag to
disable it. These are gitignored — leave them alone, and don't commit one.

The formatter is opinionated and lossy: two-space indent, no column alignment,
and it collapses wrapped expressions onto one long line. Don't fight it. Write a
comment that needs to span lines as its own block *above* the statement, not as
a trailing continuation — trailing comment lines get de-indented to column 0 and
end up looking orphaned.

VS Code formats `.scad` on save via the `vaaski.scadformat` extension, so a file
the user has open may already be formatted. Re-run it anyway — it's idempotent.

## Rendering

OpenSCAD has no CLI symlink; call the binary inside the app bundle:

```sh
/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD -o out.stl part/part.scad
```

Render after changing geometry and confirm the output says `manifold` and
`Status: NoError`. Override variables without editing the file using `-D`:

```sh
/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD -o out.stl -D 'tube_od=25' part/part.scad
```

Write one-off test renders to a scratch directory, not the repo. The `.stl` and
`.png` beside each source are generated distribution files: rebuild them with
`python3 scripts/build.py`, inspect the preview, and commit them with every source
change. Never edit either generated file by hand.

The build must report `manifold` and `Status: NoError` before replacing tracked
artifacts. It exports binary STL files and consistent fixed-view catalog
previews. A failed build must leave the last known-good artifacts intact.

The `.3mf` is a Bambu Studio project rather than a mesh export and remains
gitignored. The models are single-material prints, so these files hold only seam
and infill preferences — taste that reasonable people disagree about, not a
recipe worth versioning. Slicing is the user's job either way: if a source change
makes an export stale, say so and stop.

Finished-part geometry belongs in OpenSCAD; build-plate placement and print
orientation belong in the slicer. Do not change or flag source geometry merely
because a slicer may initially place it in an inconvenient orientation. Document
an orientation when it is useful, but treat rotating the finished model for
printing as a slicer concern.

## Documentation

The OpenSCAD source is canonical. Documentation follows the behavior and
parameters defined by the code, so treat a mismatch as stale documentation unless
the requested design behavior clearly says otherwise.

After every source change, make a dedicated documentation pass. Check the README,
source comments, measuring instructions, tuning guidance, derived-value
descriptions, print notes, generated STL, and preview image for content that needs
to follow the new code.

## Design conventions

- Measurements come from calipers, so parameters must be things a caliper can
  reach: outside diameters, clear gaps, edge-to-edge spans. Never ask for a
  center-to-center distance or any dimension inside a hollow solid — derive
  those instead.
- Keep measured inputs, tuning knobs, and derived values in separate labelled
  blocks, in that order.
- Guard derived geometry with `assert()` for interferences and overhangs, and
  `echo()` the derived values so they can be sanity-checked against the physical
  part before printing.

## Git

Commit and push without asking. Both are pre-authorized for routine work on this
repo: staging files, committing, and pushing to `origin/main` (the branch tracks
it, and working directly on `main` is fine here).

Never create a feature branch or open a pull request. This is a personal project
on a private remote with no review flow, so every change lands on `main`
directly. This overrides any default policy about branching before committing to
the default branch — do not branch, and do not ask whether to.

Commit each logical change as you finish it rather than batching unrelated work.
Subject line is `<gitmoji> <Title>`, imperative and capitalized, 64 chars or
fewer excluding the emoji, no trailing period — e.g. `✨ Add tube coupler`.
Common ones: ✨ feature, 🐛 fix, ♻️ refactor, 📝 docs, 🎨 formatting, 🔧 config,
🔥 remove. Add a body only when the subject needs explaining, and write it about
why, not what.

Still ask first for anything that rewrites or discards history: force-push,
`reset --hard`, rebasing pushed commits, deleting branches, or tags and
releases.
