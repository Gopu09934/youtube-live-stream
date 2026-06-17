FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
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

# Copy only required files
COPY start.sh .

RUN chmod +x start.sh

CMD ["./start.sh"]
