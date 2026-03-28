# 54: Web Servers (Apache & Nginx)

<p align="center">
  <img src="images/linux_web_servers.png" alt="Web Servers" width="800"/>
</p>

The Linux web server powers over 80% of the internet. Understanding Apache and Nginx — the two dominant HTTP servers — is essential for deploying applications, APIs, and static sites in production.

---

## 1. Apache vs Nginx

| Feature | Apache (httpd) | Nginx |
| :--- | :--- | :--- |
| **Architecture** | Process/Thread per connection | Event-driven, async |
| **Config Style** | `.htaccess` per directory | Centralized `nginx.conf` |
| **Best For** | Dynamic content, `.htaccess` flexibility | Reverse proxy, static files, high concurrency |
| **Module System** | Load at runtime (`a2enmod`) | Compiled-in modules |
| **Market Share** | ~30% | ~35% |

---

## 2. Apache Fundamentals

### Installation & Control:
```bash
sudo apt install apache2
sudo systemctl start apache2
sudo systemctl enable apache2
sudo systemctl status apache2
```

### Key Files:
| Path | Purpose |
| :--- | :--- |
| `/etc/apache2/apache2.conf` | Main configuration |
| `/etc/apache2/sites-available/` | Virtual host configs |
| `/etc/apache2/sites-enabled/` | Active virtual hosts (symlinked) |
| `/etc/apache2/mods-available/` | Available modules |
| `/var/www/html/` | Default document root |
| `/var/log/apache2/` | Access and error logs |

### Virtual Hosts:
```apache
# /etc/apache2/sites-available/mysite.conf
<VirtualHost *:80>
    ServerName mysite.com
    ServerAlias www.mysite.com
    DocumentRoot /var/www/mysite
    ErrorLog ${APACHE_LOG_DIR}/mysite-error.log
    CustomLog ${APACHE_LOG_DIR}/mysite-access.log combined
</VirtualHost>
```

```bash
sudo a2ensite mysite.conf         # Enable the site
sudo a2dissite 000-default.conf   # Disable default
sudo apache2ctl configtest        # Validate syntax
sudo systemctl reload apache2     # Apply changes
```

---

## 3. Nginx Fundamentals

### Installation & Control:
```bash
sudo apt install nginx
sudo systemctl start nginx
sudo systemctl enable nginx
sudo nginx -t                      # Test configuration
sudo systemctl reload nginx        # Apply changes
```

### Key Files:
| Path | Purpose |
| :--- | :--- |
| `/etc/nginx/nginx.conf` | Main configuration |
| `/etc/nginx/sites-available/` | Server block configs |
| `/etc/nginx/sites-enabled/` | Active server blocks |
| `/var/www/html/` | Default document root |
| `/var/log/nginx/` | Access and error logs |

### Server Blocks (Virtual Hosts):
```nginx
# /etc/nginx/sites-available/mysite
server {
    listen 80;
    server_name mysite.com www.mysite.com;
    root /var/www/mysite;
    index index.html;

    location / {
        try_files $uri $uri/ =404;
    }

    access_log /var/log/nginx/mysite-access.log;
    error_log /var/log/nginx/mysite-error.log;
}
```

---

## 4. Reverse Proxy with Nginx

Route traffic from Nginx to a backend application (Node.js, Python, Java, etc.):

```nginx
server {
    listen 80;
    server_name api.mysite.com;

    location / {
        proxy_pass http://127.0.0.1:3000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

---

## 5. TLS/SSL with Let's Encrypt

```bash
# Install Certbot
sudo apt install certbot python3-certbot-nginx

# Obtain and auto-configure certificate
sudo certbot --nginx -d mysite.com -d www.mysite.com

# Auto-renewal (runs via systemd timer)
sudo certbot renew --dry-run
```

---

## 🧪 Hands-On Lab

### Setup: Docker Sandbox
```bash
docker run -it --rm -p 8080:80 ubuntu:latest bash
apt-get update > /dev/null 2>&1 && apt-get install -y nginx curl > /dev/null 2>&1
```

### Exercise 1: Start Nginx and Serve a Page
> **Goal:** Launch Nginx and verify it serves content.
```bash
echo "<h1>Hello from Nginx Lab!</h1>" > /var/www/html/index.html
nginx
curl -s http://localhost
```
✅ **Expected:** Your custom HTML is returned by the local Nginx server.

### Exercise 2: View Access Logs
> **Goal:** See HTTP requests logged by Nginx.
```bash
curl -s http://localhost > /dev/null
curl -s http://localhost/nonexistent > /dev/null
cat /var/log/nginx/access.log
cat /var/log/nginx/error.log
```
✅ **Expected:** The access log shows a 200 and a 404. The error log shows the "not found" entry.

### Exercise 3: Test Configuration Syntax
> **Goal:** Validate Nginx config before applying.
```bash
nginx -t
```
✅ **Expected:** "syntax is ok" and "test is successful" — always run this before `reload`!

---

[<< Previous: DNS & DHCP](./53_DNS_and_DHCP.md) | [Home: Curriculum Map](./README.md) | [Next: SSH Deep Dive >>](./55_SSH_Deep_Dive.md)
