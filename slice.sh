#!/usr/bin/env bash
# Usage: ./slice.sh <scad_file> [output_dir]
# //output:name:call(); tags render each call to its own .stl

set -euo pipefail

[[ $# -lt 1 ]] && { echo "Usage: $0 <file.scad> [output_dir]" >&2; exit 1; }
[[ ! -f "$1" ]] && { echo "Error: $1 not found" >&2; exit 1; }

SCAD_FILE="$1"
BASENAME="$(basename "$SCAD_FILE" .scad)"
SCAD_DIR="$(cd "$(dirname "$SCAD_FILE")" && pwd)"
OUT="${2:-output}/$BASENAME"

mkdir -p "$OUT"
rm -f "$OUT"/*.stl

BUILD="$(mktemp -d)"
trap 'rm -rf "$BUILD"' EXIT

# Copy a local .scad into the build dir without its //view section, then do the
# same for everything it includes -- an included file's view geometry would
# otherwise be welded into every part rendered from this file.
strip_views() {
    local src="$1" dst="$2" inc
    sed '/^\/\/view/,$d' "$src" > "$dst"
    while IFS= read -r inc; do
        [[ -f "$SCAD_DIR/$inc" && ! -f "$BUILD/$inc" ]] || continue
        strip_views "$SCAD_DIR/$inc" "$BUILD/$inc"
    done < <(sed -n 's|^include <\([^/>]*\.scad\)>.*|\1|p' "$dst")
}

strip_views "$SCAD_FILE" "$BUILD/.stripped.scad"

if ! grep -q '//output:' "$SCAD_FILE"; then
    echo "Rendering $SCAD_FILE -> $OUT/$BASENAME.stl ..."
    openscad -o "$OUT/$BASENAME.stl" "$BUILD/.stripped.scad"
else
    while IFS= read -r tag; do
        name="${tag%%:*}"
        call="${tag#*:}"
        printf 'include <.stripped.scad>\n%s\n' "$call" > "$BUILD/.render.scad"
        echo "Rendering $call -> $OUT/$name.stl ..."
        openscad -o "$OUT/$name.stl" "$BUILD/.render.scad"
    done < <(sed -n 's|.*//output:||p' "$SCAD_FILE")
fi
