#!/bin/bash
# Initialize DVWA database and set security to low.
# Called automatically by `make start` after containers are up.

DVWA_URL="http://10.10.10.20"
MAX_WAIT=30

echo "[*] Waiting for DVWA to be ready..."
for i in $(seq 1 $MAX_WAIT); do
    if curl -s -o /dev/null -w '%{http_code}' "$DVWA_URL/login.php" 2>/dev/null | grep -q '200\|302'; then
        break
    fi
    sleep 1
done

COOKIE_JAR=$(mktemp)

# Create / reset the DVWA database via setup.php
echo "[*] Initializing DVWA database..."
SETUP_PAGE=$(curl -s -c "$COOKIE_JAR" "$DVWA_URL/setup.php")
TOKEN=$(echo "$SETUP_PAGE" | grep -oP "user_token.*?value=['\"]\\K[a-f0-9]+")

if [ -z "$TOKEN" ]; then
    echo "[!] Could not extract CSRF token -- DVWA may already be initialized"
else
    curl -s -b "$COOKIE_JAR" -c "$COOKIE_JAR" \
        -d "create_db=Create+%2F+Reset+Database&user_token=$TOKEN" \
        "$DVWA_URL/setup.php" -o /dev/null
    echo "[+] DVWA database created"
fi

# Log in to verify everything works
LOGIN_PAGE=$(curl -s -c "$COOKIE_JAR" "$DVWA_URL/login.php")
TOKEN=$(echo "$LOGIN_PAGE" | grep -oP "user_token.*?value=['\"]\\K[a-f0-9]+")

curl -s -b "$COOKIE_JAR" -c "$COOKIE_JAR" -L \
    -d "username=admin&password=password&Login=Login&user_token=$TOKEN" \
    "$DVWA_URL/login.php" -o /dev/null

echo "[+] DVWA ready (admin/password, security=low)"
rm -f "$COOKIE_JAR"
