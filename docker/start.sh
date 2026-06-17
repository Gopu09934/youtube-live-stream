#!/bin/bash

set -e

mkdir -p /app/videos

FILE_ID="${GOOGLE_DRIVE_FILE_ID}"
OUTPUT="/app/videos/video.mp4"

echo "Downloading video..."

# Download
wget -O "$OUTPUT" \
"https://drive.google.com/uc?export=download&id=${FILE_ID}"

echo "Checking file..."

# ❌ Prevent HTML fake file issue
if ! ffprobe "$OUTPUT" >/dev/null 2>&1; then
    echo "ERROR: Invalid video file downloaded (Google Drive blocked or returned HTML)"
    echo "Deleteing bad file..."
    rm -f "$OUTPUT"
    exit 1
fi

echo "Download OK"
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
