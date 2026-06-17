FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    ffmpeg \
    python3 \
    python3-pip \
    nodejs \
    npm \
    && pip3 install --break-system-packages playwright \
    && npx playwright install chromium \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY start.sh .
COPY extract.js .

RUN chmod +x start.sh

CMD ["./start.sh"]
