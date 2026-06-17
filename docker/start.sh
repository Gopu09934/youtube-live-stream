#!/bin/bash

set -e

echo "🎥 Starting ISS live stream system..."

VIDEO_URL="https://www.youtube.com/live/FuuC4dpSQ1M"

mkdir -p /app/media

# -----------------------------
# Update yt-dlp safely
# -----------------------------
echo "🔄 Updating yt-dlp..."
yt-dlp -U || true

# -----------------------------
# Try extracting YouTube stream
# -----------------------------
echo "📡 Trying to extract stream..."

STREAM_URL=$(yt-dlp --js-runtimes node -f b -g "$VIDEO_URL" 2>/dev/null || true)

# -----------------------------
# Decide input source
# -----------------------------
if [ -n "$STREAM_URL" ]; then
    echo "✅ YouTube stream extracted successfully"
    INPUT="$STREAM_URL"
else
    echo "❌ YouTube extraction failed (bot protection / JS issue)"
    echo "⚠️ Using fallback stream..."

    # SAFE fallback (always works)
    INPUT="https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4"
fi

# -----------------------------
# Safety check
# -----------------------------
if [ -z "$INPUT" ]; then
    echo "❌ No valid input stream found"
    exit 1
fi

echo "🚀 Starting FFmpeg stream..."

# -----------------------------
# STREAM TO YOUTUBE
# -----------------------------
ffmpeg -re -stream_loop -1 \
-i "$INPUT" \
-c:v libx264 -preset veryfast -pix_fmt yuv420p \
-c:a aac -b:a 128k \
-f flv "rtmp://a.rtmp.youtube.com/live2/${YOUTUBE_STREAM_KEY}"
