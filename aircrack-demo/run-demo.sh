#!/bin/zsh
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR"

IMAGE_NAME="aircrack-demo"
CAPTURE_FILE="capture.cap"
CAPTURE_URL="https://github.com/aircrack-ng/aircrack-ng/raw/master/test/wpa.cap"

echo ""
echo "=========================================="
echo "  AIRCRACK-NG DEMO — WPA Password Crack"
echo "=========================================="
echo ""
echo "WHAT THIS DEMO DOES:"
echo "  1. We have a captured WPA handshake file (capture.cap)"
echo "     — This is what an attacker captures when a device connects to WiFi"
echo "  2. We have a wordlist of common passwords (wordlist.txt)"
echo "  3. Aircrack-ng will try every password in the list against the handshake"
echo "  4. If the WiFi password is in our wordlist, it gets cracked!"
echo ""

# Download practice capture if missing
if [[ ! -f "$CAPTURE_FILE" ]]; then
  echo "[Step 1/3] Downloading practice WPA2 handshake capture..."
  curl -fSL "$CAPTURE_URL" -o "$CAPTURE_FILE"
  echo ""
else
  echo "[Step 1/3] Capture file already exists — skipping download"
fi

# Build container with capture baked in
echo "[Step 2/3] Building Docker container with aircrack-ng..."
docker build -q -t "$IMAGE_NAME" . > /dev/null
echo "  Container ready!"
echo ""

echo "[Step 3/3] Cracking the WPA handshake..."
echo "  Wordlist:  wordlist.txt ($(wc -l < wordlist.txt | tr -d ' ') passwords)"
echo "  Capture:   $CAPTURE_FILE"
echo ""
echo "--- aircrack-ng output below ---"
echo ""

docker run --rm "$IMAGE_NAME" aircrack-ng "$CAPTURE_FILE" -w wordlist.txt

echo ""
echo "=========================================="
echo "  TAKEAWAY: Weak passwords get cracked"
echo "  in under a second. Use strong, random"
echo "  passphrases for your WiFi networks!"
echo "=========================================="
