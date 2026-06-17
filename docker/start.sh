#!/bin/bash

set -e

echo "🎥 Starting browser stream system..."

URL="https://www.youtube.com/watch?v=FuuC4dpSQ1M"

STREAM_URL=$(node extract.js "$URL")

if [ -z "$STREAM_URL" ]; then
    echo "❌ No stream found (YouTube likely blocked extraction)"
    exit 1
fi

echo "✅ Stream URL:"
echo "$STREAM_URL"

ffmpeg -re -i "$STREAM_URL" \
-c:v libx264 -preset veryfast -pix_fmt yuv420p \
-c:a aac -b:a 128k \
-f flv "rtmp://a.rtmp.youtube.com/live2/${YOUTUBE_STREAM_KEY}"
