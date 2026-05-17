# 🔓 HackCraft Workshop

**Practical Cybersecurity Tools Training**

A hands-on, Docker-based cybersecurity lab environment for the HackCraft workshop. Clone this repo, run one command, and start hacking — ethically.

## 🎯 What You'll Learn

| Day | Topic | Type |
|-----|-------|------|
| **Day 1** | Network Scanning (Nmap), Service Enumeration, Wireless Security (Aircrack-ng demo) | Hands-on + Demo |
| **Day 2** | Vulnerability Assessment, Exploitation (Metasploit), Mini CTF Challenge | Hands-on + CTF |

## 📋 Prerequisites

- **Docker Desktop** installed and running ([Setup Guide](SETUP.md))
- **8 GB RAM** minimum (we run 4 containers)
- A terminal (Terminal on Mac, PowerShell/WSL on Windows)
- Basic comfort typing commands (we'll guide you through everything)

## 🚀 Quick Start

```bash
# 1. Clone this repository
git clone <repo-url>
cd hackcraft-workshop

# 2. Start the lab environment (first run downloads ~3 GB of images)
docker compose up -d

# 3. Verify all containers are running
docker compose ps

# 4. Connect to the attacker machine
docker exec -it kali bash

# 5. Start with Lab 1!
# See: labs/day1/lab1-network-scanning.md
```

## 🖥️ Lab Environment

Once started, you'll have 4 machines on an isolated network:

| Machine | IP Address | Role |
|---------|-----------|------|
| **kali** | 10.10.10.10 | Your attacker machine (Nmap, Metasploit, Hydra, etc.) |
| **dvwa** | 10.10.10.20 | Damn Vulnerable Web Application |
| **metasploitable** | 10.10.10.30 | Intentionally vulnerable Linux server |
| **ctf-server** | 10.10.10.40 | Custom CTF challenge server with 5 hidden flags |

> ⚠️ **These are intentionally vulnerable machines.** Never expose them to the internet. The Docker network is isolated by default.

## 📚 Lab Guides

### Day 1 — Recon & Scanning
1. [Lab 1: Network Scanning with Nmap](labs/day1/lab1-network-scanning.md)
2. [Lab 2: Service Enumeration & DVWA](labs/day1/lab2-enumeration.md)
3. [Demo: Wireless Security (Aircrack-ng)](labs/day1/demo-aircrack.md)

### Day 2 — Exploitation & CTF
4. [Lab 3: Vulnerability Assessment](labs/day2/lab3-vulnerability-assessment.md)
5. [Lab 4: Exploitation with Metasploit](labs/day2/lab4-metasploit.md)
6. [Lab 5: Mini CTF Challenge](labs/day2/lab5-ctf.md)

### Reference
- [Command Cheatsheet](cheatsheet.md) — Quick reference for all tools

## 🛑 Stopping the Lab

```bash
# Stop all containers
docker compose down

# Stop and remove all data (fresh start)
docker compose down -v
```

## ⚖️ Ethics Statement

This lab environment is for **educational purposes only**. The techniques taught here should only be used:
- On systems you own or have explicit permission to test
- In authorized penetration testing engagements
- In CTF competitions and lab environments

**Unauthorized access to computer systems is illegal.** Always practice responsible disclosure.

## 🛠️ Troubleshooting

| Problem | Solution |
|---------|----------|
| `docker compose up` fails | Make sure Docker Desktop is running. Try `docker compose down -v` then `up -d` again |
| Containers start but can't ping each other | Run `docker network inspect hackcraft-workshop_hackcraft-net` to verify IPs |
| Kali tools missing | Rebuild: `docker compose build --no-cache kali` |
| DVWA shows "Access denied" | Wait 30 seconds after startup, then refresh. Default login: `admin` / `password` |
| Metasploitable won't start | It needs ~1 GB RAM. Close other apps or use the lightweight profile |
| Low on RAM | Use lightweight mode: `docker compose up -d kali dvwa ctf-server` (skips Metasploitable) |
