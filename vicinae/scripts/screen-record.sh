#!/bin/bash

# @vicinae.schemaVersion 1
# @vicinae.title Screen Record
# @vicinae.mode silent
# @vicinae.packageName Capture
# @vicinae.icon 🎥
# @vicinae.keywords ["record", "capture", "video"]
# @vicinae.description Start a region screen recording with optional audio or webcam, or stop the current one

REC="$HOME/.local/bin/capture-screenrecording"

if pgrep -f "^gpu-screen-recorder" >/dev/null; then
  choice=$(printf 'Stop recording\n' | vicinae dmenu -n 'Screen Record' -s 'Recording in progress')
  case "$choice" in
    Stop*) exec "$REC" --stop-recording ;;
    *) exit 0 ;;
  esac
fi

choice=$(printf 'Region\nRegion + desktop audio\nRegion + mic\nRegion + desktop + mic\nWebcam overlay\nStop recording\n' | vicinae dmenu -n 'Screen Record' -p 'Record...')
case "$choice" in
  'Region')                    exec "$REC" ;;
  'Region + desktop audio')    exec "$REC" --with-desktop-audio ;;
  'Region + mic')              exec "$REC" --with-microphone-audio ;;
  'Region + desktop + mic')    exec "$REC" --with-desktop-audio --with-microphone-audio ;;
  'Webcam overlay')            exec "$REC" --with-webcam --with-desktop-audio ;;
  'Stop recording')            exec "$REC" --stop-recording ;;
  *)                           exit 0 ;;
esac
