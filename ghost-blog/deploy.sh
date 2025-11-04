#!/bin/bash

# Deployment script for Raspberry Pi

# Exit on any error
set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}Starting Ghost deployment to Raspberry Pi...${NC}"

# Check if running on Raspberry Pi
if ! grep -q "Raspberry Pi" /proc/cpuinfo 2>/dev/null; then
    echo -e "${YELLOW}Warning: Not running on a Raspberry Pi. This script is intended for Raspberry Pi deployment.${NC}"
fi

# Update system packages
echo -e "${YELLOW}Updating system packages...${NC}"
sudo apt update

# Install Node.js if not present
if ! command -v node &> /dev/null; then
    echo -e "${YELLOW}Installing Node.js...${NC}"
    curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -
    sudo apt-get install -y nodejs
fi

# Install nginx if not present
if ! command -v nginx &> /dev/null; then
    echo -e "${YELLOW}Installing nginx...${NC}"
    sudo apt-get install -y nginx
fi

# Install required build tools
echo -e "${YELLOW}Installing build tools...${NC}"
sudo apt-get install -y build-essential python3-dev

# Create ghost user if it doesn't exist
if ! id "ghost" &>/dev/null; then
    echo -e "${YELLOW}Creating ghost user...${NC}"
    sudo useradd -r -s /bin/false ghost
fi

# Create directories
echo -e "${YELLOW}Creating directories...${NC}"
sudo mkdir -p /var/www/space-ghost
sudo chown $USER:$USER /var/www/space-ghost

# Copy files (assuming script is run from the ghost-blog directory)
echo -e "${YELLOW}Copying files...${NC}"
cp -r ./* /var/www/space-ghost/
cp -r ./.* /var/www/space-ghost/ 2>/dev/null || true

# Set permissions
echo -e "${YELLOW}Setting permissions...${NC}"
sudo chown -R ghost:ghost /var/www/space-ghost
sudo chmod -R 755 /var/www/space-ghost

# Install dependencies
echo -e "${YELLOW}Installing Node.js dependencies...${NC}"
cd /var/www/space-ghost
npm install --production

# Create systemd service file
echo -e "${YELLOW}Creating systemd service...${NC}"
sudo tee /etc/systemd/system/ghost.service > /dev/null <<EOF
[Unit]
Description=Ghost Blog
After=network.target

[Service]
Type=simple
User=ghost
WorkingDirectory=/var/www/space-ghost
ExecStart=/usr/bin/node start.js
Restart=always
RestartSec=10
StandardOutput=syslog
StandardError=syslog
SyslogIdentifier=ghost
Environment=NODE_ENV=production

[Install]
WantedBy=multi-user.target
EOF

# Create nginx configuration
echo -e "${YELLOW}Creating nginx configuration...${NC}"
sudo tee /etc/nginx/sites-available/space-ghost.org > /dev/null <<EOF
server {
    listen 80;
    server_name space-ghost.org www.space-ghost.org;

    location / {
        proxy_pass http://127.0.0.1:2368;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
        proxy_buffering off;
    }
}
EOF

# Enable nginx site
sudo ln -sf /etc/nginx/sites-available/space-ghost.org /etc/nginx/sites-enabled/
sudo nginx -t && sudo systemctl reload nginx

# Start and enable Ghost service
echo -e "${YELLOW}Starting Ghost service...${NC}"
sudo systemctl daemon-reload
sudo systemctl enable ghost
sudo systemctl start ghost

echo -e "${GREEN}Deployment completed successfully!${NC}"
echo -e "${YELLOW}Ghost should now be running. Check the status with: sudo systemctl status ghost${NC}"
echo -e "${YELLOW}The site should be accessible at http://space-ghost.org (if DNS is configured)${NC}"