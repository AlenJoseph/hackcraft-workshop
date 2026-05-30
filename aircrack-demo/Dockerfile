FROM ubuntu:22.04
RUN apt-get update && apt-get install -y aircrack-ng curl && rm -rf /var/lib/apt/lists/*
WORKDIR /demo
COPY wordlist.txt capture.cap* ./
