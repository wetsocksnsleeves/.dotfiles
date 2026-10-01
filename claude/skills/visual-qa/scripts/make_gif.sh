#!/usr/bin/env bash
# Assemble an ordered PNG frame sequence into a GIF.
# Frames must sort lexicographically in playback order (frame-01.png, frame-02.png, ...).
# Usage: make_gif.sh <frames_dir> <output.gif> [seconds_per_frame] [width_px]
set -euo pipefail

DIR="${1:?usage: make_gif.sh <frames_dir> <output.gif> [seconds_per_frame] [width_px]}"
OUT="${2:?output path required}"
SECS="${3:-1.2}"
WIDTH="${4:-900}"
RATE="$(awk -v s="$SECS" 'BEGIN { printf "%.4f", 1/s }')"

COUNT=$(find "$DIR" -maxdepth 1 -name '*.png' | wc -l | tr -d ' ')
[ "$COUNT" -ge 2 ] || { echo "need >=2 frames in $DIR, found $COUNT" >&2; exit 1; }

ffmpeg -y -loglevel error \
  -framerate "$RATE" -pattern_type glob -i "$DIR/*.png" \
  -vf "scale=${WIDTH}:-2:flags=lanczos,split[s0][s1];[s0]palettegen=stats_mode=diff[p];[s1][p]paletteuse=dither=bayer" \
  -loop 0 "$OUT"

echo "$OUT ($COUNT frames, ${SECS}s each, $(du -h "$OUT" | cut -f1))"
