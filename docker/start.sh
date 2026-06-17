#!/bin/bash

set -euo pipefail

URL="https://www.youtube.com/watch?v=uwXgcTc8oY8"

mkdir -p /app/videos

echo "🎥 Fetching live stream URL..."

STREAM_URL=$(yt-dlp -f best -g "$URL")

if [ -z "$STREAM_URL" ]; then
  echo "❌ Failed to get stream URL"
  exit 1
fi

echo "▶️ Starting stream..."

while true; do
  ffmpeg \
    -re \
    -i "$STREAM_URL" \
    -c:v libx264 \
    -preset veryfast \
    -tune zerolatency \
    -maxrate 3000k \
    -bufsize 6000k \
    -g 50 \
    -c:a aac \
    -b:a 128k \
    -ar 44100 \
    -f flv \
    "rtmp://a.rtmp.youtube.com/live2/${YOUTUBE_STREAM_KEY}"

  echo "⚠️ Stream stopped. Reconnecting in 5 seconds..."
  sleep 5

  STREAM_URL=$(yt-dlp -f best -g "$URL")
done
