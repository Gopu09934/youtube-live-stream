#!/bin/bash

set -e

echo "🎥 Starting BROWSER YouTube LIVE system..."

URL="https://www.youtube.com/watch?v=FuuC4dpSQ1M"

echo "🌐 Extracting stream using real browser..."

STREAM_URL=$(node extract.js "$URL")

if [ -z "$STREAM_URL" ]; then
    echo "❌ Browser failed (YouTube blocked or no manifest found)"
    exit 1
fi

echo "✅ Stream found:"
echo "$STREAM_URL"

echo "🚀 Starting FFmpeg..."

ffmpeg -re -i "$STREAM_URL" \
-c:v libx264 -preset veryfast -pix_fmt yuv420p \
-c:a aac -b:a 128k \
-f flv "rtmp://a.rtmp.youtube.com/live2/${YOUTUBE_STREAM_KEY}"
