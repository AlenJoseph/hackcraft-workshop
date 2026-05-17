FROM kalilinux/kali-rolling

# Avoid interactive prompts during package install
ENV DEBIAN_FRONTEND=noninteractive

# Update and install essential pentesting tools
RUN apt-get update && apt-get install -y --no-install-recommends \
    nmap \
    hydra \
    dirb \
    gobuster \
    sqlmap \
    curl \
    wget \
    net-tools \
    iputils-ping \
    dnsutils \
    netcat-traditional \
    nikto \
    vim \
    less \
    metasploit-framework \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Copy wordlists into the container
COPY wordlists/ /usr/share/wordlists/custom/

WORKDIR /root

# Keep the container running
CMD ["bash"]
