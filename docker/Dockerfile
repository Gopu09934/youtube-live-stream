FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

# Install system dependencies + Node.js (IMPORTANT for yt-dlp JS runtime)
RUN apt-get update && \
    apt-get install -y \
        ffmpeg \
        python3 \
        python3-pip \
        curl \
        ca-certificates \
        nodejs \
        npm && \
    pip3 install --break-system-packages -U yt-dlp gdown && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy script
COPY start.sh .

# OPTIONAL: cookies (don’t fail build if missing)
COPY cookies.txt /app/cookies.txt || true

RUN chmod +x start.sh

# Ensure yt-dlp uses JS runtime properly
ENV YTDLP_JS_RUNTIME=node

CMD ["./start.sh"]
