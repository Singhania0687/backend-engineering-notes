
This will be **industry-standard style**, covering:

* HTTP/HTTPS
* Reverse proxy
* Load balancing
* SSL/TLS (server + optional client verification)
* WebSocket support
* Static files / SPA handling
* Logging
* Rate limiting
* Caching
* Timeout settings
* Security headers

---

```nginx
# =====================================================================
# GLOBAL SETTINGS
# =====================================================================

# Number of worker processes (usually number of CPU cores)
worker_processes auto;

# Error log for NGINX (useful for debugging)
error_log /var/log/nginx/error.log warn;

# PID file
pid /var/run/nginx.pid;

# =====================================================================
# EVENTS BLOCK
# Controls how NGINX handles low-level connections
# =====================================================================
events {
    # Maximum number of simultaneous connections per worker
    worker_connections 1024;
    # Use efficient event method (auto = epoll/kqueue depending on OS)
    use auto;
    multi_accept on;
}

# =====================================================================
# HTTP BLOCK
# All HTTP/HTTPS configuration goes here
# =====================================================================
http {
    # -----------------------------
    # BASIC SETTINGS
    # -----------------------------
    include       /etc/nginx/mime.types;       # MIME type mapping
    default_type  application/octet-stream;

    sendfile        on;                        # Enable high-performance file transfer
    tcp_nopush      on;                        # Optimize file sending
    tcp_nodelay     on;                        # Reduce latency
    keepalive_timeout 65;                      # Keep-alive timeout in seconds
    types_hash_max_size 2048;

    # -----------------------------
    # LOGGING
    # -----------------------------
    access_log /var/log/nginx/access.log main;
    log_format main '$remote_addr - $remote_user [$time_local] "$request" '
                    '$status $body_bytes_sent "$http_referer" '
                    '"$http_user_agent" "$http_x_forwarded_for"';

    # -----------------------------
    # RATE LIMITING (protect API)
    # -----------------------------
    limit_req_zone $binary_remote_addr zone=api_limit:10m rate=10r/s;

    # -----------------------------
    # CACHE (optional proxy cache)
    # -----------------------------
    proxy_cache_path /var/cache/nginx levels=1:2 keys_zone=my_cache:10m max_size=1g inactive=60m use_temp_path=off;

    # -----------------------------
    # LOAD BALANCING BACKENDS
    # -----------------------------
    upstream backend {
        # Multiple Node.js servers
        server localhost:3000;
        server localhost:3001;

        # Load balancing method examples
        # least_conn;  # distribute requests to server with least connections
        # ip_hash;     # sticky session based on client IP
    }

    # -----------------------------
    # MAIN SERVER (HTTP → redirect to HTTPS)
    # -----------------------------
    server {
        listen 80;
        server_name example.com www.example.com;

        # Redirect all HTTP requests to HTTPS
        return 301 https://$host$request_uri;
    }

    # -----------------------------
    # SECURE SERVER (HTTPS)
    # -----------------------------
    server {
        listen 443 ssl http2;  # Enable HTTP/2
        server_name example.com www.example.com;

        # -----------------------------
        # SSL SETTINGS
        # -----------------------------
        ssl_certificate /etc/ssl/certs/server.crt;
        ssl_certificate_key /etc/ssl/private/server.key;

        # Strong recommended protocols and ciphers
        ssl_protocols TLSv1.2 TLSv1.3;
        ssl_ciphers 'ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384';
        ssl_prefer_server_ciphers on;
        ssl_session_cache shared:SSL:10m;

        # Optional: Mutual TLS (client certificates)
        # ssl_client_certificate /etc/ssl/certs/ca.pem;
        # ssl_verify_client on;

        # -----------------------------
        # SECURITY HEADERS
        # -----------------------------
        add_header X-Frame-Options "SAMEORIGIN" always;
        add_header X-XSS-Protection "1; mode=block" always;
        add_header X-Content-Type-Options "nosniff" always;
        add_header Referrer-Policy "no-referrer-when-downgrade" always;
        add_header Content-Security-Policy "default-src 'self';" always;

        # -----------------------------
        # API LOCATION (Reverse Proxy + WebSocket)
        # -----------------------------
        location /api/ {
            # Proxy to backend upstream
            proxy_pass http://backend;

            # Preserve headers
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;

            # WebSocket support
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection "upgrade";

            # HTTP version for backend
            proxy_http_version 1.1;

            # Timeouts
            proxy_connect_timeout 5s;
            proxy_send_timeout 10s;
            proxy_read_timeout 30s;

            # Rate limiting
            limit_req zone=api_limit burst=20 nodelay;

            # Optional caching
            proxy_cache my_cache;
            proxy_cache_valid 200 10m;
            proxy_cache_use_stale error timeout updating;
        }

        # -----------------------------
        # STATIC FILES (frontend SPA)
        # -----------------------------
        location / {
            root /var/www/frontend;
            index index.html;
            try_files $uri /index.html;  # SPA routing fallback
        }

        # -----------------------------
        # CUSTOM ERROR PAGES
        # -----------------------------
        error_page 404 /404.html;
        location = /404.html {
            root /var/www/errors;
            internal;
        }

        error_page 500 502 503 504 /50x.html;
        location = /50x.html {
            root /var/www/errors;
            internal;
        }
    }
}
```

---

## ✅ Features Covered

| Feature               | Directive / Section                           | Notes                     |
| --------------------- | --------------------------------------------- | ------------------------- |
| HTTP → HTTPS redirect | `return 301 https://$host$request_uri;`       | Force SSL                 |
| SSL/TLS               | `listen 443 ssl;`, `ssl_certificate`          | Encrypted traffic         |
| HTTP/2                | `http2`                                       | Faster multiplexing       |
| Mutual TLS            | `ssl_client_certificate`, `ssl_verify_client` | Optional, client auth     |
| Reverse Proxy         | `proxy_pass`                                  | Forward API requests      |
| WebSocket             | `proxy_set_header Upgrade/Connection`         | Real-time apps            |
| Rate Limiting         | `limit_req_zone` + `limit_req`                | Protect backend from spam |
| Load Balancing        | `upstream backend`                            | Multiple Node.js servers  |
| Timeout Config        | `proxy_connect_timeout`, etc.                 | Protect NGINX workers     |
| Headers               | `proxy_set_header`                            | Forward client info       |
| Security Headers      | `add_header`                                  | Prevent XSS, clickjacking |
| Logging               | `access_log`, `error_log`                     | Debug & analytics         |
| SPA support           | `try_files $uri /index.html`                  | React/Vue routing         |
| Caching               | `proxy_cache`                                 | Reduce backend load       |
| Custom error pages    | `error_page`                                  | Friendly UI for errors    |

---

### 🔑 Tips to Remember

1. **Blocks first:** `events {}` → `http {}` → `server {}` → `location {}`
2. **HTTP vs HTTPS:** redirect HTTP → HTTPS, main traffic handled in HTTPS block
3. **Proxy to backend:** `proxy_pass` + headers + timeouts
4. **Frontend SPA:** `try_files` trick
5. **Extras:** logging, rate limiting, caching, security headers

---
