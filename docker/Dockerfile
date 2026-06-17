FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y \
        ffmpeg \
        python3 \
        python3-pip \
        curl \
        ca-certificates && \
    pip3 install --break-system-packages gdown yt-dlp && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY start.sh .
COPY cookies.txt /app/cookies.txt

RUN chmod +x start.sh

CMD ["./start.sh"]
