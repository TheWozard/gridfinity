#!/usr/bin/env bash
# Usage: ./slice.sh <scad_file> [output_dir]
# Renders a .scad file to .stl
# //output: tags in the file render each call to its own .stl

set -euo pipefail

if [[ $# -lt 1 ]]; then
    echo "Usage: $0 <file.scad> [output_dir]" >&2
    exit 1
fi

SCAD_FILE="$1"
OUTPUT_DIR="${2:-output}"

if [[ ! -f "$SCAD_FILE" ]]; then
    echo "Error: $SCAD_FILE not found" >&2
    exit 1
fi

BASENAME="$(basename "$SCAD_FILE" .scad)"
SCAD_ABS="$(realpath "$SCAD_FILE")"
mkdir -p "$OUTPUT_DIR/$BASENAME"

TMPDIR_="$(mktemp -d)"
trap 'rm -rf "$TMPDIR_"' EXIT

STRIPPED="$TMPDIR_/stripped.scad"
sed '/^\/\/view/,$d' "$SCAD_FILE" > "$STRIPPED"

render_call() {
    local call="$1" stl="$2"
    printf 'include <%s>\n%s\n' "$STRIPPED" "$call" > "$TMPDIR_/render.scad"
    echo "Rendering $call -> $stl ..."
    openscad -o "$stl" "$TMPDIR_/render.scad"
}

tags=()
while IFS= read -r line; do
    tag="$(echo "$line" | sed 's|.*//output:||' | xargs)"
    [[ -n "$tag" ]] && tags+=("$tag")
done < <(grep '//output:' "$SCAD_FILE" || true)

if [[ ${#tags[@]} -eq 0 ]]; then
    echo "Rendering $SCAD_FILE -> $OUTPUT_DIR/$BASENAME/$BASENAME.stl ..."
    openscad -o "$OUTPUT_DIR/$BASENAME/$BASENAME.stl" "$STRIPPED"
else
    for tag in "${tags[@]}"; do
        name="${tag%%:*}"
        call="${tag#*:}"
        render_call "$call" "$OUTPUT_DIR/$BASENAME/${name}.stl"
    done
fi
