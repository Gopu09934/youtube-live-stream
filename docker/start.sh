#!/bin/bash

set -e

echo "🎥 Starting stable streaming system..."

VIDEO_URL="https://www.youtube.com/live/FuuC4dpSQ1M"

mkdir -p /app/media

echo "🔄 Updating yt-dlp..."
yt-dlp -U || true

# -----------------------------
# TRY YOUTUBE
# -----------------------------
echo "📡 Trying YouTube stream..."

STREAM_URL=$(yt-dlp --js-runtimes node -f b -g "$VIDEO_URL" 2>/dev/null || true)

if [ -n "$STREAM_URL" ]; then
    echo "✅ YouTube stream found"
    INPUT="$STREAM_URL"
else
    echo "❌ YouTube blocked"

    # -----------------------------
    # SAFE FALLBACK (WORKING MP4)
    # NASA public video (stable CDN)
    # -----------------------------
    INPUT="https://download.samplelib.com/mp4/sample-720x480.mp4"
fi

# -----------------------------
# FINAL SAFETY CHECK
# -----------------------------
echo "📺 Input source: $INPUT"

# -----------------------------
# START STREAM
# -----------------------------
ffmpeg -re -stream_loop -1 \
-i "$INPUT" \
-c:v libx264 -preset veryfast -pix_fmt yuv420p \
-c:a aac -b:a 128k \
-f flv "rtmp://a.rtmp.youtube.com/live2/${YOUTUBE_STREAM_KEY}"
