#!/bin/bash

set -e

mkdir -p /app/videos

FILE_ID="${GOOGLE_DRIVE_FILE_ID}"
OUTPUT="/app/videos/video.mp4"

echo "Downloading video..."

# Try wget first (most stable)
if command -v wget >/dev/null 2>&1; then
  wget -O "$OUTPUT" \
  "https://drive.google.com/uc?export=download&id=${FILE_ID}" || true
fi

# Fallback if wget fails or file empty
if [ ! -s "$OUTPUT" ]; then
  echo "wget failed, trying fallback method..."

  curl -L \
  "https://drive.google.com/uc?export=download&id=${FILE_ID}" \
  -o "$OUTPUT" || true
fi

# Final check
if [ ! -s "$OUTPUT" ]; then
  echo "ERROR: Download failed. Google Drive is blocking access."
  exit 1
fi

echo "Download complete"
echo "Starting stream..."

ffmpeg \
-re \
-stream_loop -1 \
-i "$OUTPUT" \
-c:v libx264 \
-preset veryfast \
-c:a aac \
-f flv \
"rtmp://a.rtmp.youtube.com/live2/${YOUTUBE_STREAM_KEY}"
