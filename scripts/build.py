import argparse
import os
import re
import platform
import shutil
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
MACOS_OPENSCAD = Path("/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD")
PREVIEW_SIZE = "1200,900"
PREVIEW_CAMERA = "0,0,0,55,0,25,0"
PREVIEW_COLORSCHEME = "Tomorrow"

# OpenSCAD reports both on success; matched as one phrase so an unrelated
# "NoError" elsewhere in the output can't stand in for the status line
MANIFOLD_RESULT = re.compile(r"\(manifold\):\s*\n\s*Status:\s*NoError")


class BuildError(RuntimeError):
    pass


def executable_candidates():
    configured = os.environ.get("OPENSCAD")
    if configured:
        yield Path(configured).expanduser()

    on_path = shutil.which("openscad")
    if on_path:
        yield Path(on_path)

    if MACOS_OPENSCAD.exists():
        yield MACOS_OPENSCAD

    if os.name == "nt":
        program_files = Path(os.environ.get("PROGRAMFILES", "C:/Program Files"))
        windows_openscad = program_files / "OpenSCAD" / "openscad.exe"
        if windows_openscad.exists():
            yield windows_openscad


def command_candidates():
    seen = set()
    arch = shutil.which("arch")

    for executable in executable_candidates():
        direct = (str(executable),)
        if direct not in seen:
            seen.add(direct)
            yield list(direct)

        if sys.platform == "darwin" and platform.machine() == "arm64" and arch:
            translated = (arch, "-x86_64", str(executable))
            if translated not in seen:
                seen.add(translated)
                yield list(translated)


def find_openscad():
    failures = []

    for command in command_candidates():
        try:
            result = subprocess.run(
                [*command, "--version"],
                capture_output=True,
                check=False,
                text=True,
            )
        except OSError:
            # Candidate isn't runnable — a stale OPENSCAD value, or a path that
            # existed at discovery and doesn't now. Try the next one
            failures.append(" ".join(command))
            continue
        if result.returncode == 0:
            version = (result.stdout or result.stderr).strip()
            print(f"Using {version}")
            return command
        failures.append(" ".join(command))

    attempted = ", ".join(failures) if failures else "no installed candidates"
    raise BuildError(
        "OpenSCAD CLI not found. Install OpenSCAD or set OPENSCAD to its executable "
        f"path. Attempted: {attempted}"
    )


def discover_sources(requested):
    if requested:
        sources = [Path(value).expanduser().resolve() for value in requested]
    else:
        sources = sorted(ROOT.glob("*/*.scad"))

    if not sources:
        raise BuildError("No object sources found")

    for source in sources:
        if not source.is_file() or source.suffix.lower() != ".scad":
            raise BuildError(f"Not an OpenSCAD source file: {source}")
        if source.parent.parent != ROOT:
            raise BuildError(
                f"Object source must be one folder below the repository root: {source}"
            )

    return sources


def run_export(command, label):
    result = subprocess.run(
        command,
        cwd=ROOT,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        check=False,
        text=True,
    )
    if result.stdout:
        print(result.stdout, end="")
    if result.returncode != 0:
        raise BuildError(f"{label} failed with exit code {result.returncode}")
    if not MANIFOLD_RESULT.search(result.stdout):
        raise BuildError(f"{label} did not report a manifold NoError result")


def build_model(openscad, source):
    stem = source.stem
    stl = source.with_suffix(".stl")
    preview = source.with_suffix(".png")
    temp_stl = source.with_name(f".{stem}.tmp.stl")
    temp_preview = source.with_name(f".{stem}.tmp.png")
    relative_source = source.relative_to(ROOT)

    print(f"\nBuilding {relative_source}")

    for temp_file in (temp_stl, temp_preview):
        temp_file.unlink(missing_ok=True)

    try:
        run_export(
            [
                *openscad,
                "--hardwarnings",
                "--export-format",
                "binstl",
                "-o",
                str(temp_stl),
                str(source),
            ],
            f"STL export for {relative_source}",
        )
        run_export(
            [
                *openscad,
                "--hardwarnings",
                "--render",
                "--autocenter",
                "--viewall",
                "--projection",
                "ortho",
                "--camera",
                PREVIEW_CAMERA,
                "--imgsize",
                PREVIEW_SIZE,
                "--colorscheme",
                PREVIEW_COLORSCHEME,
                "-o",
                str(temp_preview),
                str(source),
            ],
            f"PNG export for {relative_source}",
        )
        temp_stl.replace(stl)
        temp_preview.replace(preview)
    finally:
        temp_stl.unlink(missing_ok=True)
        temp_preview.unlink(missing_ok=True)

    print(f"Wrote {stl.relative_to(ROOT)}")
    print(f"Wrote {preview.relative_to(ROOT)}")


def parse_args():
    parser = argparse.ArgumentParser(
        description="Build tracked STL and PNG files from object OpenSCAD sources"
    )
    parser.add_argument(
        "sources",
        nargs="*",
        help="Object .scad files to build; defaults to every object",
    )
    return parser.parse_args()


def main():
    args = parse_args()
    try:
        sources = discover_sources(args.sources)
        openscad = find_openscad()
        for source in sources:
            build_model(openscad, source)
    except BuildError as error:
        print(f"error: {error}", file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
