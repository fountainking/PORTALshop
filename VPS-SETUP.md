# PORTALshop VPS Deployment Guide

## Quick Start

### 1. One-Time VPS Setup

SSH into your VPS and run these commands:

```bash
# Update system
sudo apt update && sudo apt upgrade -y

# Install nginx
sudo apt install nginx -y

# Create web directory
sudo mkdir -p /var/www/portal

# Set permissions
sudo chown -R $USER:$USER /var/www/portal
```

### 2. Configure Nginx

Create nginx config:

```bash
sudo nano /etc/nginx/sites-available/portal
```

Paste this configuration:

```nginx
server {
    listen 80;
    server_name lab0172.236.230.200;

    root /var/www/portal;
    index index.html;

    # Enable gzip compression
    gzip on;
    gzip_types text/html text/css application/javascript;

    location / {
        try_files $uri $uri/ =404;

        # Cache control for static assets
        add_header Cache-Control "public, max-age=0";
    }

    # Disable caching for development
    location ~* \.(html|js|css)$ {
        add_header Cache-Control "no-cache, no-store, must-revalidate";
        add_header Pragma "no-cache";
        add_header Expires "0";
    }
}
```

Enable the site:

```bash
# Link config
sudo ln -s /etc/nginx/sites-available/portal /etc/nginx/sites-enabled/

# Remove default site (optional)
sudo rm /etc/nginx/sites-enabled/default

# Test nginx config
sudo nginx -t

# Restart nginx
sudo systemctl restart nginx
```

### 3. Deploy from Your Local Machine

Edit `deploy.sh` if needed (change VPS_USER if not root):

```bash
chmod +x deploy.sh
./deploy.sh
```

Your site will be live at: http://lab0172.236.230.200

## Development Workflow

### Deploy Changes

Every time you make changes:

```bash
./deploy.sh
```

Then refresh your mobile browser to see updates.

### Fast Deploy (One-Liner)

```bash
./deploy.sh && echo "Deployed! Refresh your phone browser."
```

### Watch and Auto-Deploy (macOS)

Install fswatch:

```bash
brew install fswatch
```

Then run:

```bash
fswatch -o index.html 200w.gif | xargs -n1 -I{} ./deploy.sh
```

This auto-deploys whenever you save files.

## Mobile Testing

1. Connect to the same network as your VPS (or use VPS public IP)
2. Open browser on phone: http://lab0172.236.230.200
3. Add to home screen for app-like experience
4. Edit code locally, run `./deploy.sh`, refresh on phone

## Optional: HTTPS Setup

If you have a domain name:

```bash
# Install certbot
sudo apt install certbot python3-certbot-nginx -y

# Get SSL certificate
sudo certbot --nginx -d yourdomain.com

# Auto-renewal is configured automatically
```

## Troubleshooting

**Can't access from phone?**
- Check VPS firewall: `sudo ufw allow 80`
- Verify nginx is running: `sudo systemctl status nginx`
- Check VPS IP is correct: `curl ifconfig.me`

**Changes not showing?**
- Hard refresh on phone (usually settings in browser menu)
- Clear browser cache
- Check deployment worked: `./deploy.sh`

**Nginx errors?**
- Check logs: `sudo tail -f /var/log/nginx/error.log`
- Test config: `sudo nginx -t`
