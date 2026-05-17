# 🐳 Docker Setup Guide

Step-by-step instructions to install Docker on your machine.

---

## macOS

1. Go to [https://www.docker.com/products/docker-desktop/](https://www.docker.com/products/docker-desktop/)
2. Click **"Download for Mac"** (choose Apple Silicon or Intel based on your Mac)
3. Open the downloaded `.dmg` file and drag Docker to Applications
4. Launch **Docker Desktop** from Applications
5. Wait for the Docker icon in the menu bar to show "Docker Desktop is running"
6. Open **Terminal** and verify:

```bash
docker --version
# Should show: Docker version 24.x or higher

docker compose version
# Should show: Docker Compose version v2.x
```

---

## Windows

### Option A: Docker Desktop (Recommended)

1. Go to [https://www.docker.com/products/docker-desktop/](https://www.docker.com/products/docker-desktop/)
2. Click **"Download for Windows"**
3. Run the installer — accept defaults
4. **Important:** When prompted, enable **WSL 2** backend (not Hyper-V)
5. Restart your computer if prompted
6. Launch **Docker Desktop**
7. Open **PowerShell** and verify:

```powershell
docker --version
docker compose version
```

### Option B: WSL 2 + Docker (Advanced)

If you already have WSL 2 with Ubuntu:

```bash
# Inside WSL 2 Ubuntu
sudo apt update
sudo apt install docker.io docker-compose-v2
sudo usermod -aG docker $USER
# Log out and back in, then:
docker --version
```

---

## Linux (Ubuntu/Debian)

```bash
# Update package index
sudo apt update

# Install prerequisites
sudo apt install -y ca-certificates curl gnupg

# Add Docker's official GPG key
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# Add the repository
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

# Add your user to the docker group (so you don't need sudo)
sudo usermod -aG docker $USER

# Log out and back in, then verify:
docker --version
docker compose version
```

---

## ✅ Verification

After installing, run this to confirm everything works:

```bash
docker run hello-world
```

You should see: **"Hello from Docker!"**

---

## System Requirements

| Requirement | Minimum | Recommended |
|-------------|---------|-------------|
| RAM | 8 GB | 16 GB |
| Disk Space | 10 GB free | 20 GB free |
| CPU | 2 cores | 4 cores |
| Internet | Required for first `docker compose up` (downloads ~3 GB) | — |

---

## 💡 Tips

- **First run is slow** — Docker downloads all the images (~3 GB total). After that, it's instant.
- **Keep Docker Desktop running** during the entire workshop.
- **If you're low on RAM**, skip Metasploitable:
  ```bash
  docker compose up -d kali dvwa ctf-server
  ```
- **Windows users:** Use PowerShell or WSL 2 terminal, not Command Prompt (cmd).
