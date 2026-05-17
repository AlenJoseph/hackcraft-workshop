# Aircrack-ng Demo Resources

This directory contains pre-recorded files for the Aircrack-ng wireless security demo.

## Files

- `wordlist.txt` — Small wordlist containing the demo password
- `capture.cap` — **Not included** (see below)

## Creating the Demo Capture File

Since `.cap` files require actual wireless hardware to generate, you have two options:

### Option 1: Use a Practice File
Download a practice WPA2 handshake from:
- https://www.aircrack-ng.org/doku.php?id=wpa_capture
- Save as `capture.cap` in this directory

### Option 2: Create Your Own
If you have a wireless adapter that supports monitor mode:
```bash
airmon-ng start wlan0
airodump-ng -c 6 --bssid <your_AP_MAC> -w capture wlan0mon
# From another terminal:
aireplay-ng --deauth 5 -a <your_AP_MAC> wlan0mon
# Wait for "WPA handshake" to appear, then Ctrl+C
```

## Demo Command
```bash
aircrack-ng capture.cap -w wordlist.txt
```
