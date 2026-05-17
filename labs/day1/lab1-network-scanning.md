# Lab 1: Network Scanning with Nmap

**Duration:** ~30 minutes  
**Difficulty:** Beginner  
**Tools:** Nmap

## 🎯 Objective

Discover all machines on the lab network and identify their open ports and running services.

## 📖 Background

**Nmap** (Network Mapper) is the most widely used network scanning tool in cybersecurity. It helps you answer:
- What devices are on this network?
- What ports are open on each device?
- What services and versions are running?

This is the **first step** in any penetration test — you can't hack what you can't see.

---

## 🔧 Getting Started

First, connect to your Kali attacker machine:

```bash
docker exec -it kali bash
```

You should see a prompt like:
```
root@kali:~#
```

Verify Nmap is installed:
```bash
nmap --version
```

---

## Exercise 1: Host Discovery

**Goal:** Find all live machines on the `10.10.10.0/24` network.

### What to type:

```bash
nmap -sn 10.10.10.0/24
```

### What this does:
- `-sn` = Ping scan (no port scan) — just checks which hosts are alive
- `10.10.10.0/24` = Scan the entire subnet (256 addresses)

### Expected output (similar to):

```
Starting Nmap 7.94 ( https://nmap.org ) at 2026-05-29 18:30 UTC
Nmap scan report for 10.10.10.1
Host is up (0.00012s latency).
Nmap scan report for 10.10.10.10
Host is up (0.00008s latency).
Nmap scan report for 10.10.10.20
Host is up (0.00015s latency).
Nmap scan report for 10.10.10.30
Host is up (0.00020s latency).
Nmap scan report for 10.10.10.40
Host is up (0.00013s latency).
Nmap done: 256 IP addresses (5 hosts up) scanned in 2.05 seconds
```

### 📝 Questions to answer:
1. How many hosts did Nmap discover?
2. Which IP is the gateway? (Hint: it's usually `.1`)
3. Which IP is YOUR machine? (Hint: `.10`)

---

## Exercise 2: Port Scanning

**Goal:** Find open ports on the DVWA server (10.10.10.20).

### What to type:

```bash
nmap 10.10.10.20
```

### What this does:
- Scans the **top 1000 most common ports** on the target
- Shows which ports are **open**, **closed**, or **filtered**

### Understanding port states:
| State | Meaning |
|-------|---------|
| `open` | A service is listening and accepting connections |
| `closed` | Port is accessible but no service is listening |
| `filtered` | A firewall is blocking the port |

### Expected output:
```
PORT   STATE SERVICE
80/tcp open  http
```

### Try it on the CTF server too:
```bash
nmap 10.10.10.40
```

### 📝 Questions:
1. What port is the web server running on?
2. How many ports are open on the CTF server?
3. What additional service does the CTF server have that DVWA doesn't?

---

## Exercise 3: Service Version Detection

**Goal:** Identify exactly what software is running on each open port.

### What to type:

```bash
nmap -sV 10.10.10.40
```

### What this does:
- `-sV` = Version detection — probes open ports to determine service name and version
- This gives you much more detail than a basic scan

### Expected output (similar to):
```
PORT   STATE SERVICE VERSION
22/tcp open  ssh     OpenSSH 9.x (protocol 2.0)
80/tcp open  http    nginx 1.24.x
```

### Why this matters:
Knowing the exact software version lets you search for known vulnerabilities. For example:
- OpenSSH 7.2 has a username enumeration vulnerability
- Apache 2.4.49 has a path traversal vulnerability
- Specific versions of nginx, vsftpd, etc. have known exploits

---

## Exercise 4: Aggressive Scan

**Goal:** Get maximum information about the Metasploitable server.

### What to type:

```bash
nmap -A 10.10.10.30
```

### What this does:
`-A` enables **aggressive mode**, which combines:
- `-sV` (version detection)
- `-sC` (default NSE scripts)
- `-O` (OS detection)
- `--traceroute`

> ⚠️ This scan is **noisy** — in a real pentest, this would likely be detected by intrusion detection systems (IDS). In our lab, that's fine!

### Expected output (partial):
```
PORT     STATE SERVICE     VERSION
21/tcp   open  ftp         vsftpd 2.3.4
22/tcp   open  ssh         OpenSSH 4.7p1 Debian
23/tcp   open  telnet      Linux telnetd
25/tcp   open  smtp        Postfix smtpd
80/tcp   open  http        Apache httpd 2.2.8
...
```

### 📝 Questions:
1. How many open ports does Metasploitable have? (Hint: it's a LOT — that's why it's vulnerable)
2. What version of FTP server is running? (This will be important in Day 2!)
3. What operating system is detected?

---

## Exercise 5: Targeted Scan with Output

**Goal:** Save a detailed scan to a file for later reference.

```bash
nmap -sV -sC -oN /root/scan-results.txt 10.10.10.0/24
```

### What this does:
- `-sC` = Run default NSE scripts (safe scripts that gather extra info)
- `-oN /root/scan-results.txt` = Save output to a file in "normal" format

### View the saved results:
```bash
cat /root/scan-results.txt
```

---

## 🏆 Summary

You've learned how to:

| Command | Purpose |
|---------|---------|
| `nmap -sn <network>` | Discover live hosts |
| `nmap <target>` | Scan top 1000 ports |
| `nmap -sV <target>` | Detect service versions |
| `nmap -A <target>` | Aggressive scan (versions + scripts + OS) |
| `nmap -oN file.txt <target>` | Save results to a file |

---

## ➡️ Next: [Lab 2: Service Enumeration & DVWA](lab2-enumeration.md)
