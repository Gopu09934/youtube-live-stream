#!/bin/bash

set -e

mkdir -p /app/videos

echo "Downloading video..."

wget -O /app/videos/video.mp4 \
"https://github.com/Gopu09934/youtube-live-stream/releases/download/v1/Live.High-Definition.Views.from.the.International.Space.Station.Official.NASA.Stream.mp4"

echo "Checking file..."

ffprobe /app/videos/video.mp4 >/dev/null

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
