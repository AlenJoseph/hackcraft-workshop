# Lab 2: Service Enumeration & DVWA Recon

**Duration:** ~30 minutes  
**Difficulty:** Beginner  
**Tools:** Nmap NSE scripts, curl, web browser (inside Kali)

## 🎯 Objective

Use advanced Nmap scripts to enumerate services in detail, then explore the DVWA (Damn Vulnerable Web Application) to understand how web apps expose attack surfaces.

---

## Part A: Nmap NSE Scripts

NSE (Nmap Scripting Engine) has hundreds of built-in scripts for deeper enumeration. Let's use them.

### Exercise 1: Vulnerability Scan with NSE

Connect to Kali if you haven't:
```bash
docker exec -it kali bash
```

Run a vulnerability scan against Metasploitable:

```bash
nmap --script vuln 10.10.10.30
```

### What this does:
- `--script vuln` = Runs all scripts in the "vuln" category
- These scripts check for **known vulnerabilities** on each open port

### Expected output (partial):
```
PORT   STATE SERVICE
21/tcp open  ftp
| ftp-vsftpd-backdoor:
|   VULNERABLE:
|   vsFTPd version 2.3.4 backdoor
|     State: VULNERABLE (Exploitable)
|     IDs:  CVE:2011-2523
...
```

### 📝 Key finding:
The vsftpd 2.3.4 service has a **known backdoor**! We'll exploit this in Day 2, Lab 4.

---

### Exercise 2: HTTP Enumeration

Enumerate the web server on DVWA:

```bash
nmap --script http-enum 10.10.10.20
```

This discovers directories and files on the web server:
```
PORT   STATE SERVICE
80/tcp open  http
| http-enum:
|   /login.php: Login page
|   /setup.php: Setup page
|   /config/: Configuration directory
...
```

Try the CTF server too:

```bash
nmap --script http-enum 10.10.10.40
```

---

### Exercise 3: Grab HTTP Headers with curl

Let's look at what information the CTF server reveals in its HTTP headers:

```bash
curl -I http://10.10.10.40
```

### What this does:
- `curl` = Command-line HTTP client
- `-I` = Fetch only the HTTP headers (HEAD request)

### Look carefully at the output!
```
HTTP/1.1 200 OK
Server: nginx/1.24.0
...
```

> 💡 **Pay close attention to ALL the headers.** Servers sometimes leak information they shouldn't...

---

## Part B: Exploring DVWA

### Exercise 4: Access DVWA

From the Kali container, use curl to check DVWA is up:

```bash
curl -s http://10.10.10.20 | head -20
```

**From your host machine's browser**, you can also access DVWA:
- Open: `http://localhost:80` (if port 80 is mapped) or use `docker inspect dvwa` to find the IP

**Inside the Docker network**, DVWA is at: `http://10.10.10.20`

### Exercise 5: Login to DVWA

Default credentials:
- **Username:** `admin`
- **Password:** `password`

### Exercise 6: Setup the Database

After logging in:
1. Click **"Create / Reset Database"** on the setup page
2. You'll be redirected to the login page — log in again

### Exercise 7: Set Security Level

1. Click **"DVWA Security"** in the left menu
2. Change security level to **"Low"**
3. Click **Submit**

> In "Low" security mode, DVWA intentionally has no protections — perfect for learning.

---

### Exercise 8: Explore DVWA Modules

Browse through these sections (don't exploit them yet — just observe):

| Module | What it teaches |
|--------|----------------|
| **Command Injection** | Running OS commands through a web form |
| **SQL Injection** | Extracting data from databases |
| **XSS (Reflected)** | Injecting JavaScript into pages |
| **File Upload** | Uploading malicious files |
| **Brute Force** | Password guessing attacks |

For each module:
1. Read the description
2. Try the normal functionality (enter valid input)
3. Think: "How could an attacker misuse this?"

---

### Exercise 9: Quick Command Injection Test

Go to **Command Injection** in DVWA:

1. The page asks you to enter an IP address to ping
2. Enter a normal IP: `10.10.10.10` — observe the output
3. Now try: `10.10.10.10; whoami`

### What happened?
The `;` character ended the ping command and started a new one (`whoami`). This is **command injection** — the web app is executing your input as a system command without sanitizing it.

### Try these:
```
10.10.10.10; id
10.10.10.10; cat /etc/passwd
10.10.10.10; ls -la /
```

> 🔴 **This is dangerous in real applications!** An attacker could read files, install malware, or take over the server entirely.

---

## 🏆 Summary

You've learned:

| Skill | Tools Used |
|-------|-----------|
| Vulnerability scanning | `nmap --script vuln` |
| Web directory enumeration | `nmap --script http-enum` |
| HTTP header inspection | `curl -I` |
| Web app reconnaissance | DVWA exploration |
| Command injection (intro) | DVWA Command Injection module |

### Key takeaways:
- NSE scripts automate vulnerability detection
- HTTP headers can leak sensitive information
- Web applications often accept more input than intended
- Always test with "Low" security first to understand the vulnerability

---

## ➡️ Next: [Demo: Wireless Security (Aircrack-ng)](demo-aircrack.md)
