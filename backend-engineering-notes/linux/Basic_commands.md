# LINUX

Linux is the backbone of backend engineering. From servers to cloud, understanding Linux commands is essential.
## 1️⃣ File & Directory Management (Daily use)

### 📁 Navigation

```bash
pwd            # current directory
ls             # list files
ls -la         # detailed + hidden files
cd /path       # move
cd ..          # one level up
cd ~           # home
```

### 📄 Create / Delete

```bash
touch file.txt
mkdir dir
mkdir -p a/b/c     # nested dirs
rm file.txt
rm -r dir
rm -rf dir         # ⚠️ force delete (be careful)
```

### 📦 Copy / Move

```bash
cp a.txt b.txt
cp -r dir1 dir2
mv old new
```

💡 **Use case**: managing project files, build outputs, logs

---

## 2️⃣ File Viewing & Editing (VERY IMPORTANT)

### 👀 View files

```bash
cat file.txt
less file.txt     # scroll
head file.txt
tail file.txt
tail -f app.log   # live logs (🔥 interview fav)
```

### ✏️ Edit files

```bash
nano file.txt     # beginner
vim file.txt      # must know basics
```

💡 **Use case**: config files, logs, env files

---

## 3️⃣ Permissions & Ownership (INTERVIEW GOLD)

### 🔐 Permissions

```bash
ls -l
chmod 755 file.sh
chmod +x script.sh
```

### 👤 Ownership

```bash
chown user:group file
```

🔎 Permission meaning:

```
r = read
w = write
x = execute
```

💡 **Use case**: scripts not running, prod issues

---

## 4️⃣ Search & Text Processing (Backend Engineers LOVE this)

### 🔍 Find files

```bash
find . -name "*.log"
```

### 🔎 Search inside files

```bash
grep "error" app.log
grep -i "error" app.log
grep -r "TODO" .
```

### 🧹 Text tools

```bash
wc -l file.txt
sort file.txt
uniq file.txt
cut -d":" -f1 file.txt
```

💡 **Use case**: logs, debugging, analytics

---

## 5️⃣ Process & System Monitoring (VERY IMPORTANT)

### 🧠 Processes

```bash
ps aux
top
htop          
```

### 🛑 Kill process

```bash
kill PID
kill -9 PID
```

### ⚙️ System info

```bash
free -h
df -h
du -sh folder
uptime
```

💡 **Use case**: high CPU, memory leaks, prod outages

---

## 6️⃣ Networking Commands (Backend Essential)

```bash
ifconfig            # macOS
ip a                # Linux
netstat -tulnp
ss -tulnp
curl http://localhost:3000
wget url
ping google.com
```

💡 **Use case**: APIs not reachable, port issues

---

## 7️⃣ Environment Variables (VERY VERY IMPORTANT)

```bash
export NODE_ENV=production
echo $NODE_ENV
env
```

### Persist env vars

```bash
~/.bashrc
~/.zshrc   # macOS default
```

💡 **Use case**: config, secrets, CI/CD

---

## 8️⃣ Package Management

### Ubuntu

```bash
apt update
apt install nginx
```

### macOS

```bash
brew install nginx
brew services start nginx
```

💡 **Use case**: install tools on servers

---

## 9️⃣ Disk, Mount, Logs (Production Side)

```bash
df -h
mount
lsblk
journalctl
```

💡 **Use case**: disk full, server crashes

---

## 🔟 Shell Power Moves (Must Know)

### 🔗 Pipes & Redirection

```bash
cat app.log | grep error
ls > files.txt
echo "hello" >> file.txt
```

### ⏳ Background jobs

```bash
command &
jobs
fg
bg
```

---

## 1️⃣1️⃣ SSH & Remote Servers (ABSOLUTE MUST)

```bash
ssh user@ip
scp file user@ip:/path
rsync -av src dest
```

💡 **Use case**: prod servers, deployments

---

## 1️⃣2️⃣ Archives & Compression

```bash
tar -cvf files.tar folder
tar -xvf files.tar
zip -r files.zip folder
unzip files.zip
```

---
