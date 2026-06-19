#!/bin/bash

set -euo pipefail

mkdir -p /app/videos

if [ -z "${VIDEO_URL:-}" ]; then
    echo "ERROR: VIDEO_URL is not set."
    exit 1
fi

if [ -z "${YOUTUBE_STREAM_KEY:-}" ]; then
    echo "ERROR: YOUTUBE_STREAM_KEY is not set."
    exit 1
fi

echo "Downloading video from:"
echo "$VIDEO_URL"

yt-dlp \
    -f "bv*+ba/b" \
    --merge-output-format mp4 \
    -o "/app/videos/video.mp4" \
    "$VIDEO_URL"

echo "Verifying video..."
ffprobe -v error -show_format -show_streams /app/videos/video.mp4

echo "Starting stream..."

exec ffmpeg \
    -re \
    -stream_loop -1 \
    -i /app/videos/video.mp4 \
    -c:v libx264 \
    -preset ultrafast \
    -pix_fmt yuv420p \
    -r 60 \
    -g 120 \
    -b:v 6000k \
    -maxrate 6000k \
    -bufsize 12000k \
    -c:a aac \
    -b:a 160k \
    -ar 48000 \
    -f flv \
    "rtmp://a.rtmp.youtube.com/live2/${YOUTUBE_STREAM_KEY}"
