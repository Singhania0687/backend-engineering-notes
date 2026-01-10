# NGINX

- It act as a Reverse proxy
- It provide load balancing
- It can provide static content and is much faster than node.js in so
- It provides ssl termination
- It can be used as a web Server
- It provide huge concurrent connection handling mechanism
- It improve scalability and performance

---
## 🔷 What is the **Master Process** in Nginx?

The **master process** is the **parent process** of Nginx.

### 🔑 Responsibilities of Master Process

* Reads and **validates `nginx.conf`**
* **Starts** worker processes
* **Manages** workers (restart, shutdown)
* Handles **reloads** (`nginx -s reload`)
* Runs with **higher privileges** (root)

📌 **It does NOT handle client requests**

---

## 🔷 What is a **Worker Process** in Nginx?

Worker processes are **child processes** created by the master.

### 🔑 Responsibilities of Worker Processes

* Handle **all client requests**
* Manage **connections**
* Perform **I/O operations**
* Serve HTTP/TCP traffic

📌 Workers run as a **non-root user** (security)

---

## 🧠 How They Work Together

1. Master starts
2. Master reads config
3. Master spawns workers
4. Workers handle traffic
5. Master monitors workers

---

## 🔢 How Many Workers?

Defined in **main context**:

```nginx
worker_processes auto;
```

* `auto` → equals number of CPU cores
* Best practice for performance

---

## 🔗 Workers + Events (Important Link)

```nginx
events {
    worker_connections 1024;
}
```

### Max connections:

```text
max_connections = worker_processes × worker_connections
```

---

## 🔍 View Master & Workers (macOS)

```bash
ps aux | grep nginx
```

Output:

```text
root     nginx: master process /opt/homebrew/bin/nginx
nobody   nginx: worker process
nobody   nginx: worker process
```

---

## 🛡️ Why This Design? (Big Advantage)

* **High performance**
* **Non-blocking I/O**
* **Fault tolerant** (worker crash ≠ downtime)
* **Hot reload** without stopping server

---

## 🧠 Simple Analogy (Interview Friendly)

| Nginx   | Real World |
| ------- | ---------- |
| Master  | Manager    |
| Worker  | Employees  |
| Clients | Customers  |

Manager manages, employees work.

---

## 🎯 Interview One-Liner (Perfect)

> “Nginx uses a master–worker architecture where the master manages configuration and lifecycle, and worker processes handle all client requests using an event-driven model.”

---
## Basic Settings

- brew install nginx
<pre>
  nginx                # start
  nginx -s stop        # stop
  nginx -s reload      # reload config
  nginx -t             # test config
</pre>

- configuration file is located at ` /opt/homebrew/etc/nginx/nginx.conf`


## Core NGINX structure
<pre>
 main context
    ├── events
    └── http
      ├── upstream
      └── server
           └── location

  </pre>

### Main context
<pre>
The main context:
     Exists outside of events {}, http {}, server {}, etc.
     Applies globally to the entire Nginx process
     Affects master & worker processes

     Used for global settings like:
            user
            worker_processes
            error_log
            pid 
</pre>


---

# 🧠 What is `events` Context in NGINX?

> The `events` context controls **how NGINX handles low-level connections** between clients and NGINX workers.

It has **nothing to do with routing, APIs, proxying, or backend logic**.

---

# 🏗 Where `events` Fits in NGINX

NGINX has **two layers**:

```
OS-level connection handling  →  events {}
HTTP-level request handling  →  http {}
```

So:

* `events {}` → **TCP connections**
* `http {}` → **HTTP requests**

That’s the key distinction.

---

# 🔍 Why `events` Exists

NGINX is famous because it:

* handles **100k+ concurrent connections**
* uses **event-driven, non-blocking I/O**

The `events` block tells NGINX:

* how many connections each worker can handle
* which OS event system to use (epoll / kqueue)

---

# 🧩 What Goes Inside `events {}`

In **99% of backend work**, you’ll see just this:

```nginx
events {
    worker_connections 1024;
}
```

That’s it.

---

# 🔑 Most Important Directive: `worker_connections`

### What it means:

> Maximum number of simultaneous connections **per worker process**

Example:

```nginx
worker_processes 4;
worker_connections 1024;
```

Total connections ≈

```
4 × 1024 = ~4096 connections
```

---

# 🧠 Memory Hook (VERY IMPORTANT)

> **events = connections, not requests**

Requests live in `http {}`
Connections live in `events {}`

Once you remember this, confusion ends.

---

# 🧪 Do Backend Engineers Tune `events`?

### Real answer:

❌ Almost never

### Why?

* Defaults are already good
* Cloud load balancers sit in front
* Horizontal scaling is preferred

Only infra / SRE teams tune this heavily.

---


# 🧱 Minimal Safe Template (USE THIS ALWAYS)

```nginx
events {
    worker_connections 1024;
}

http {
    server {
        listen 80;

        location / {
            proxy_pass http://localhost:3000;
        }
    }
}
```

This is **100% acceptable** in interviews and real projects.

---

# ⚠️ Common Mistake (DO NOT DO THIS)

❌ Trying to put:

```nginx
proxy_pass
location
server
```

inside `events {}`

👉 That’s an instant red flag.

---

# 🧠 One-Line Mental Summary (WRITE THIS DOWN)

> **events = connection handling**
> **http = request handling**

---


## Treasure Chest 
---

## ✅ Correct Mental Model (Simple & Clean)

### 🔹 **Main context**

👉 **Controls Nginx as a whole**

* Global settings
* Process management
* Worker creation
* Security (`user`)
* Logging

📌 *Does NOT handle traffic directly*

---

### 🔹 **Events block**

👉 **Controls how connections are handled**

* How many connections
* Event-driven mechanism
* Low-level networking behavior

📌 *Connection handling, not request logic*

---

### 🔹 **HTTP block**

👉 **Handles HTTP requests**

* Websites
* APIs
* Routing
* Reverse proxy
* Load balancing (HTTP)

📌 *This is where real web logic lives*

---

## 🧠 One-Line Summary (Perfect)

> **Main manages Nginx itself, events manage connections, and http manages requests.**

---

## 🔗 Putting It Together (Visual)

```
Main (Nginx control)
 ├── Events (Connections)
 └── HTTP (Requests)
      └── Server (Virtual hosts)
           └── Location (URL handling)
```

---

## ❗ Small but Important Note

* **Connections ≠ Requests**
* A single connection can handle **multiple HTTP requests** (keep-alive)

---


## Protocols supported by NGINX are :-

Nginx officially supports **three main protocol contexts**:

## 1️⃣ `http`

* For **web traffic** (HTTP/HTTPS)
* Handles:

  * Websites
  * REST APIs
  * Reverse proxy & load balancing
* Uses blocks like `server` and `location`

```nginx
http {
    server {
        listen 80;
    }
}
```

---

## 2️⃣ `stream`

* For **TCP/UDP traffic**
* Handles:

  * MySQL, Redis, SSH, MQTT, any TCP/UDP service
* Uses blocks like `server` inside `stream`

```nginx
stream {
    server {
        listen 3306;
        proxy_pass 127.0.0.1:3306;
    }
}
```

---

## 3️⃣ `mail`

* For **email protocols**
* Handles:

  * SMTP, IMAP, POP3
* Less commonly used

```nginx
mail {
    server {
        listen 25;
        protocol smtp;
    }
}
```

---

### ❌ Notes:

* You **cannot define arbitrary protocols**; only these three are officially supported.
* `main` and `events` are **not protocols**, they are contexts for configuration.
* Each protocol has its **own top-level block**, just like `http`.

---

### 🔗 Summary Table

| Context | Handles                          |
| ------- | -------------------------------- |
| main    | Global Nginx settings            |
| events  | Connections & worker behavior    |
| http    | HTTP/HTTPS requests              |
| stream  | TCP/UDP traffic                  |
| mail    | Email protocols (SMTP/IMAP/POP3) |

---
##  Nginx Directives

## 1️⃣ `proxy_pass`

### **What it does:**

It tells NGINX **where to forward the request** — basically your **backend server**.

### **Use case:**

You have a Node.js API running on `localhost:3000`.
Client requests come to NGINX at `/api`. You want NGINX to forward all `/api` requests to Node.js.

```nginx
location /api {
    proxy_pass http://localhost:3000;
}
```

**Mental hook:**

> “Client talks to NGINX, NGINX talks to backend.”
> **proxy_pass = ‘backend address’**

---

## 2️⃣ `proxy_set_header`

### **What it does:**

Adds or overwrites HTTP headers when NGINX forwards a request.

### **Use case:**

* Node.js wants **real client IP**, not NGINX’s IP.
* Node.js wants **host info** to route requests correctly.

```nginx
proxy_set_header Host $host;
proxy_set_header X-Real-IP $remote_addr;
proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
```

**Memory hook:**

> “When proxying, NGINX can fake or forward headers. These three headers are must-have.”

* `$host` → domain requested
* `$remote_addr` → client IP
* `$proxy_add_x_forwarded_for` → preserves chain of IPs

💡 **Think:** Every time your backend logs IP → this is why it works.

---

## 3️⃣ `proxy_http_version`

### **What it does:**

Sets which HTTP version NGINX uses to talk to the backend.

```nginx
proxy_http_version 1.1;
```

**Use case:**

* WebSocket or chunked transfer requires **HTTP/1.1**.
* Default is **1.0**, which can break modern APIs.

**Memory hook:**

> “If you use proxy_pass + WebSocket → must tell NGINX: use HTTP/1.1”

---

## 4️⃣ `proxy_read_timeout`

### **What it does:**

Max time NGINX waits **for the backend to send a response** after connection is established.

```nginx
proxy_read_timeout 30s;
```

**Use case:**

* Node.js API takes 25 seconds to respond → default timeout may cut it off.
* Set `proxy_read_timeout` longer than your slowest expected API.

**Memory hook:**

> “How long do I wait for the answer? → proxy_read_timeout”

---

## 5️⃣ `proxy_connect_timeout`

### **What it does:**

Max time NGINX waits **to establish connection with backend**.

```nginx
proxy_connect_timeout 5s;
```

**Use case:**

* Backend is down or unreachable → timeout after 5 seconds instead of hanging forever.
* Protects NGINX workers from getting stuck.

**Memory hook:**

> “How long to knock on backend door? → proxy_connect_timeout”

---

## 6️⃣ `proxy_send_timeout`

### **What it does:**

Max time NGINX waits **to send the request to the backend**.

```nginx
proxy_send_timeout 10s;
```

**Use case:**

* Backend is slow to read incoming request → NGINX aborts after timeout.
* Protects your server in case backend is overloaded.

**Memory hook:**

> “How long do I take to hand over the request? → proxy_send_timeout”

---

## ✅ Quick Mental Map to Remember

| Directive               | Think “What question does it answer?”             |
| ----------------------- | ------------------------------------------------- |
| `proxy_pass`            | Where do I send this request?                     |
| `proxy_set_header`      | What info should backend know about client?       |
| `proxy_http_version`    | Which HTTP version should I speak to backend?     |
| `proxy_read_timeout`    | How long will I wait for backend’s answer?        |
| `proxy_connect_timeout` | How long do I try to connect to backend?          |
| `proxy_send_timeout`    | How long will I spend sending request to backend? |

---

### 🧠 Memory Trick (Sticky)

**Sentence:**

> “I **pass** the request (`proxy_pass`) with the **right headers** (`proxy_set_header`) using HTTP/1.1 (`proxy_http_version`), wait some time to **connect** (`proxy_connect_timeout`), **send** the request (`proxy_send_timeout`), and finally **wait for response** (`proxy_read_timeout`).”

---






