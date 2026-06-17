#!/bin/bash

set -euo pipefail

mkdir -p /app/videos

VIDEO_URL="https://github.com/Gopu09934/youtube-live-stream/releases/download/v1/Live.High-Definition.Views.from.the.International.Space.Station.Official.NASA.Stream.mp4"
OUTPUT="/app/videos/video.mp4"

echo "Downloading video..."
echo "$VIDEO_URL"

curl -L --fail --retry 3 --retry-delay 5 \
  -o "$OUTPUT" \
  "$VIDEO_URL"

echo "Verifying video..."

if ! ffprobe -v error "$OUTPUT" >/dev/null 2>&1; then
    echo "ERROR: Downloaded file is not a valid video."
    exit 1
fi

echo "Starting stream..."

exec ffmpeg \
  -re \
  -stream_loop -1 \
  -i "$OUTPUT" \
  -c:v libx264 \
  -preset veryfast \
  -c:a aac \
  -f flv \
  "rtmp://a.rtmp.youtube.com/live2/${YOUTUBE_STREAM_KEY}"
