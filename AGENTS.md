# AGENTS.md

OpenSCAD source for 3D-printable parts. One self-contained `.scad` file per part
at the repo root, each with its measured dimensions as top-level variables.

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
/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD -o out.stl part.scad
```

Render after changing geometry and confirm the output says `manifold` and
`Status: NoError`. Override variables without editing the file using `-D`:

```sh
/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD -o out.stl -D 'tube_od=25' part.scad
```

Write test renders to a scratch directory, not the repo. `.stl` and `.3mf` are
both gitignored — never commit either, and never `git add -f` one. Meshes for
other people go on a GitHub Release, not into the tree.

The `.3mf` is a Bambu Studio project rather than a mesh export, but these are
single-material prints, so it holds only seam and infill preferences — taste
that reasonable people disagree about, not a recipe worth versioning. Slicing is
the user's job either way: if a source change makes an export stale, say so and
stop.

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

Commit each logical change as you finish it rather than batching unrelated work.
Subject line is `<gitmoji> <Title>`, imperative and capitalized, 64 chars or
fewer excluding the emoji, no trailing period — e.g. `✨ Add tube coupler`.
Common ones: ✨ feature, 🐛 fix, ♻️ refactor, 📝 docs, 🎨 formatting, 🔧 config,
🔥 remove. Add a body only when the subject needs explaining, and write it about
why, not what.

Still ask first for anything that rewrites or discards history: force-push,
`reset --hard`, rebasing pushed commits, deleting branches, or tags and
releases.
