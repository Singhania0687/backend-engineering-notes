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



