#!/bin/bash

set -e

echo "Starting stream..."

ffmpeg \
-re \
-stream_loop -1 \
-i "${INPUT_SOURCE}" \
-c:v libx264 \
-preset veryfast \
-b:v 3500k \
-c:a aac \
-b:a 128k \
-f flv \
"rtmp://a.rtmp.youtube.com/live2/${YOUTUBE_STREAM_KEY}"