#!/bin/bash

set -euo pipefail

URL="https://www.youtube.com/watch?v=uwXgcTc8oY8"

echo "🎥 Starting ISS live stream system..."

get_stream() {
  yt-dlp -f b \
    --cookies /app/cookies.txt \
    --no-warnings \
    --no-check-certificates \
    -g "$URL"
}

STREAM_URL=$(get_stream)

if [ -z "$STREAM_URL" ]; then
  echo "❌ Failed to fetch stream URL"
  exit 1
fi

echo "▶️ Streaming started..."

while true; do

  ffmpeg \
    -re \
    -reconnect 1 \
    -reconnect_streamed 1 \
    -reconnect_delay_max 5 \
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

  echo "⚠️ Stream dropped. Reconnecting..."

  sleep 5

  STREAM_URL=$(get_stream)

done
