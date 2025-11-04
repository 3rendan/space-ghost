#!/bin/bash

# Space Ghost Blog Raspberry Pi Deployment Script
# This script sets up Ghost on a Raspberry Pi

set -e

PI_USER="${PI_USER:-pi}"
PI_HOST="${PI_HOST:-space-ghost.local}"
PI_PATH="${PI_PATH:-/home/pi/space-ghost}"

echo "🚀 Deploying Space Ghost to Raspberry Pi..."

# Check if we can connect to the Pi
if ! ssh ${PI_USER}@${PI_HOST} "echo 'Connected to Pi'" 2>/dev/null; then
    echo "❌ Cannot connect to Raspberry Pi at ${PI_USER}@${PI_HOST}"
    echo "💡 Make sure:"
    echo "   - Pi is running and accessible"
    echo "   - SSH is enabled"
    echo "   - You have the correct hostname/IP"
    echo "   - You can set PI_USER and PI_HOST environment variables"
    exit 1
fi

# Install Docker on Pi if not already installed
echo "📦 Installing Docker on Raspberry Pi..."
ssh ${PI_USER}@${PI_HOST} '
    if ! command -v docker &> /dev/null; then
        echo "Installing Docker..."
        curl -fsSL https://get.docker.com -o get-docker.sh
        sudo sh get-docker.sh
        sudo usermod -aG docker pi
        echo "Docker installed. You may need to reboot the Pi."
    else
        echo "Docker already installed"
    fi
'

# Install Docker Compose on Pi
ssh ${PI_USER}@${PI_HOST} '
    if ! command -v docker-compose &> /dev/null; then
        echo "Installing Docker Compose..."
        sudo apt update && sudo apt install -y docker-compose
    else
        echo "Docker Compose already installed"
    fi
'

# Create directory structure on Pi
echo "📁 Creating directory structure on Pi..."
ssh ${PI_USER}@${PI_HOST} "mkdir -p ${PI_PATH}/{ghost/content/{themes,images,logs,data},mysql/data,scripts,backup}"

# Copy configuration files
echo "📋 Copying configuration files..."
rsync -avz --exclude='node_modules' --exclude='.git' \
    docker-compose.yml \
    ghost/config.production.json \
    ${PI_USER}@${PI_HOST}:${PI_PATH}/

# Copy production docker-compose (with different ports)
cat > docker-compose.prod.yml << 'EOF'
version: '3.8'

services:
  ghost:
    image: ghost:5-alpine
    restart: unless-stopped
    ports:
      - "127.0.0.1:2368:2368"
    depends_on:
      - db
    environment:
      database__client: mysql2
      database__connection__host: db
      database__connection__user: ghost
      database__connection__password: ghostdbpass
      database__connection__database: ghost
      url: https://space-ghost.org
      NODE_ENV: production
    volumes:
      - ./ghost/content:/var/lib/ghost/content
      - ./ghost/config.production.json:/var/lib/ghost/config.production.json

  db:
    image: mysql:8.0
    restart: unless-stopped
    environment:
      MYSQL_ROOT_PASSWORD: rootpassword
      MYSQL_DATABASE: ghost
      MYSQL_USER: ghost
      MYSQL_PASSWORD: ghostdbpass
    volumes:
      - ./mysql/data:/var/lib/mysql

  nginx:
    image: nginx:alpine
    restart: unless-stopped
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./nginx/nginx.conf:/etc/nginx/nginx.conf
      - ./nginx/ssl:/etc/nginx/ssl
    depends_on:
      - ghost
EOF

scp docker-compose.prod.yml ${PI_USER}@${PI_HOST}:${PI_PATH}/docker-compose.yml

# Create nginx configuration for production
echo "🌐 Setting up Nginx configuration..."
ssh ${PI_USER}@${PI_HOST} "mkdir -p ${PI_PATH}/nginx/ssl"

# Create nginx config
cat > nginx/nginx.conf << 'EOF'
events {
    worker_connections 1024;
}

http {
    upstream ghost {
        server ghost:2368;
    }

    server {
        listen 80;
        server_name space-ghost.org www.space-ghost.org;
        
        location /.well-known/acme-challenge/ {
            root /var/www/certbot;
        }
        
        location / {
            return 301 https://$server_name$request_uri;
        }
    }

    server {
        listen 443 ssl http2;
        server_name space-ghost.org www.space-ghost.org;

        ssl_certificate /etc/nginx/ssl/cert.pem;
        ssl_certificate_key /etc/nginx/ssl/key.pem;
        ssl_protocols TLSv1.2 TLSv1.3;
        ssl_ciphers HIGH:!aNULL:!MD5;

        location / {
            proxy_set_header Host $http_host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
            proxy_pass http://ghost;
        }
    }
}
EOF

scp -r nginx ${PI_USER}@${PI_HOST}:${PI_PATH}/

# Start services on Pi
echo "🐳 Starting services on Raspberry Pi..."
ssh ${PI_USER}@${PI_HOST} "
    cd ${PI_PATH}
    docker-compose down 2>/dev/null || true
    docker-compose pull
    docker-compose up -d
"

echo "✅ Deployment complete!"
echo ""
echo "🌐 Your blog should be accessible at:"
echo "   Development: http://${PI_HOST}:2368"
echo "   Admin: http://${PI_HOST}:2368/ghost"
echo ""
echo "🔒 To enable HTTPS:"
echo "1. Place your SSL certificates in nginx/ssl/"
echo "2. Restart with: docker-compose restart nginx"
echo ""
echo "📊 Monitor with: ssh ${PI_USER}@${PI_HOST} 'cd ${PI_PATH} && docker-compose logs -f'"