FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    ffmpeg \
    curl && \
    pip3 install --no-cache-dir yt-dlp

WORKDIR /app

COPY start.sh .

RUN chmod +x start.sh

CMD ["./start.sh"]
