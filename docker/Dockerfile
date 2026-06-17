FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    ffmpeg \
    curl \
    ca-certificates \
    nodejs \
    npm \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Install playwright properly
RUN npm init -y && \
    npm install playwright && \
    npx playwright install chromium

COPY start.sh .
COPY extract.js .

RUN chmod +x start.sh

CMD ["./start.sh"]
