FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y \
        ffmpeg \
        python3 \
        python3-pip \
        wget \
        curl \
        ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Install gdown (optional, but now not required)
RUN pip3 install --break-system-packages gdown

WORKDIR /app

COPY start.sh .

RUN chmod +x start.sh

CMD ["./start.sh"]
