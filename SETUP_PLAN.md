# Space-Ghost.org Setup Plan

## Current Status
✅ Ghost blog is running locally with Node.js v22.21.1
✅ Basic configuration is in place
✅ Database is initialized
✅ Site is accessible at http://localhost:2368

## Next Steps

### 1. Configure for Production Deployment
- [ ] Update configuration for production environment
- [ ] Set up proper SSL certificates for space-ghost.org
- [ ] Configure domain settings
- [ ] Optimize performance settings

### 2. Set up Content Sync Mechanism
- [ ] Create Git hooks for content synchronization
- [ ] Set up automated backup scripts
- [ ] Implement content migration tools

### 3. Raspberry Pi Deployment
- [ ] Create deployment scripts for Raspberry Pi
- [ ] Set up systemd service for automatic startup
- [ ] Configure reverse proxy (nginx)
- [ ] Set up monitoring and logging

### 4. Customization Options
- [ ] Document theme customization process
- [ ] Explain how to modify site content
- [ ] Provide guidance on adding custom features

## Directory Structure
```
space-ghost/
├── ghost-blog/           # Main Ghost installation
│   ├── content/          # Content directory (not synced to Git)
│   │   ├── apps/         # Custom apps
│   │   ├── data/         # Database files
│   │   ├── images/       # Uploaded images
│   │   ├── logs/         # Log files
│   │   ├── settings/     # Settings files
│   │   └── themes/       # Theme files
│   ├── config.*.json     # Configuration files
│   ├── index.js          # Entry point
│   └── start.js          # Custom start script
└── SETUP_PLAN.md         # This document
```

## Customization Guide

### Changing Site Settings
1. Access the admin panel at http://localhost:2368/ghost
2. Log in with the default credentials
3. Navigate to Settings to modify:
   - Site title and description
   - Logo and cover image
   - Social media accounts
   - Navigation menus

### Modifying Themes
1. Themes are located in `content/themes/`
2. Default theme is Casper
3. To modify the theme:
   - Edit files in `content/themes/casper/`
   - Or install a new theme by placing it in the themes directory
   - Activate the theme in the admin panel

### Adding Content
1. Create posts and pages through the admin panel
2. Posts are stored in the SQLite database
3. Images are stored in `content/images/`

## Deployment to Raspberry Pi

### Initial Setup
1. Install Node.js v22 on Raspberry Pi
2. Clone the repository to Raspberry Pi
3. Run `npm install` to install dependencies
4. Copy content directory or restore database

### Running as a Service
Create a systemd service file at `/etc/systemd/system/ghost.service`:

```ini
[Unit]
Description=Ghost Blog
After=network.target

[Service]
Type=simple
User=pi
WorkingDirectory=/path/to/space-ghost/ghost-blog
ExecStart=/usr/local/bin/node start.js
Restart=always
RestartSec=10
StandardOutput=syslog
StandardError=syslog
SyslogIdentifier=ghost

[Install]
WantedBy=multi-user.target
```

Then enable and start the service:
```bash
sudo systemctl enable ghost
sudo systemctl start ghost
```

### Setting up nginx as Reverse Proxy
Install nginx and create a configuration file at `/etc/nginx/sites-available/space-ghost.org`:

```nginx
server {
    listen 80;
    server_name space-ghost.org www.space-ghost.org;

    location / {
        proxy_pass http://127.0.0.1:2368;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

Enable the site:
```bash
sudo ln -s /etc/nginx/sites-available/space-ghost.org /etc/nginx/sites-enabled/
sudo systemctl reload nginx
```
