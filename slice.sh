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
trap 'rm -f "$OUT/.stripped.scad" "$OUT/.render.scad"' EXIT

sed '/^\/\/view/,$d' "$SCAD_FILE" | \
    sed "s|include <\([^/>]*\.scad\)>|include <$SCAD_DIR/\1>|g" > "$OUT/.stripped.scad"

if ! grep -q '//output:' "$SCAD_FILE"; then
    echo "Rendering $SCAD_FILE -> $OUT/$BASENAME.stl ..."
    openscad -o "$OUT/$BASENAME.stl" "$OUT/.stripped.scad"
else
    while IFS= read -r tag; do
        name="${tag%%:*}"
        call="${tag#*:}"
        printf 'include <.stripped.scad>\n%s\n' "$call" > "$OUT/.render.scad"
        echo "Rendering $call -> $OUT/$name.stl ..."
        openscad -o "$OUT/$name.stl" "$OUT/.render.scad"
    done < <(sed -n 's|.*//output:||p' "$SCAD_FILE")
fi
