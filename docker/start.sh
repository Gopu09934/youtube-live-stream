#!/bin/bash

set -e

echo "🎥 Starting ISS live stream system..."

VIDEO_URL="https://www.youtube.com/live/FuuC4dpSQ1M?si=jFllUFngkmLsElJy"

mkdir -p /app/media

echo "🔄 Updating yt-dlp..."
yt-dlp -U || true

echo "📡 Trying to extract live stream (HLS mode)..."

STREAM_URL=$(yt-dlp -f best --hls-prefer-native -g "$VIDEO_URL" 2>/dev/null || true)

if [ -z "$STREAM_URL" ]; then
    echo "❌ Failed to extract live stream URL from YouTube"
    echo "⚠️ Falling back to direct download attempt..."

    yt-dlp -f best -o /app/media/video.mp4 "$VIDEO_URL" || true

    INPUT="/app/media/video.mp4"
else
    echo "✅ Stream URL extracted successfully"
    INPUT="$STREAM_URL"
fi

echo "🚀 Starting FFmpeg stream..."

ffmpeg -re -stream_loop -1 \
-i "$INPUT" \
-c:v libx264 -preset veryfast -pix_fmt yuv420p \
-c:a aac -b:a 128k \
-f flv "rtmp://a.rtmp.youtube.com/live2/${YOUTUBE_STREAM_KEY}"
