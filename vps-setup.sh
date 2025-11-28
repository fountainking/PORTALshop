#!/bin/bash

# PORTALshop VPS Setup Script
# Run this ON your VPS: ssh lab0172.236.230.200, then run this script

set -e  # Exit on error

echo "🚀 Setting up PORTALshop on VPS..."

# Update system
echo "📦 Updating system packages..."
sudo apt update && sudo apt upgrade -y

# Install nginx
echo "📦 Installing nginx..."
sudo apt install nginx -y

# Create web directory
echo "📁 Creating web directory..."
sudo mkdir -p /var/www/portal
sudo chown -R $USER:$USER /var/www/portal

# Create nginx config
echo "⚙️  Configuring nginx..."
sudo tee /etc/nginx/sites-available/portal > /dev/null <<'EOF'
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
EOF

# Enable the site
echo "🔗 Enabling site..."
sudo ln -sf /etc/nginx/sites-available/portal /etc/nginx/sites-enabled/

# Remove default site
if [ -f /etc/nginx/sites-enabled/default ]; then
    echo "🗑️  Removing default site..."
    sudo rm /etc/nginx/sites-enabled/default
fi

# Test nginx config
echo "✅ Testing nginx configuration..."
sudo nginx -t

# Restart nginx
echo "🔄 Restarting nginx..."
sudo systemctl restart nginx

# Configure firewall
echo "🔥 Configuring firewall..."
sudo ufw allow 80/tcp 2>/dev/null || echo "Firewall not configured (that's okay)"

echo ""
echo "✨ Setup complete!"
echo ""
echo "Your server is ready at: http://lab0172.236.230.200"
echo ""
echo "Next steps:"
echo "1. Exit the VPS (type 'exit')"
echo "2. Run ./deploy.sh from your local machine"
echo ""
