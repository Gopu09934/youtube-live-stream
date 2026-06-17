#!/bin/bash

set -e

mkdir -p /app/videos

echo "Downloading video..."

wget -O /app/videos/video.mp4 \
"https://drive.google.com/uc?export=download&id=${GOOGLE_DRIVE_FILE_ID}"

echo "Starting stream..."

ffmpeg \
-re \
-stream_loop -1 \
-i /app/videos/video.mp4 \
-c:v libx264 \
-preset veryfast \
-c:a aac \
-f flv \
"rtmp://a.rtmp.youtube.com/live2/${YOUTUBE_STREAM_KEY}"
