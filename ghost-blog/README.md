# Space-Ghost Blog

A self-hosted Ghost blog for space-ghost.org

## Project Structure

```
.
├── content/              # Ghost content directory
│   ├── apps/             # Custom apps
│   ├── data/             # Database files
│   ├── images/           # Uploaded images
│   ├── logs/             # Log files
│   ├── settings/         # Settings files
│   └── themes/           # Theme files
├── node_modules/         # Node.js dependencies
├── config.development.json  # Development configuration
├── index.js              # Entry point (deprecated)
├── start.js              # Main startup script
├── deploy.sh             # Raspberry Pi deployment script
├── sync-content.sh       # Content synchronization script
├── package.json          # Node.js package file
└── README.md             # This file
```

## Development Setup

1. Install Node.js v22.x
2. Run `npm install` to install dependencies
3. Run `npm start` to start the development server
4. Access the blog at http://localhost:2368
5. Access the admin panel at http://localhost:2368/ghost

## Deployment

### To Raspberry Pi

1. Make sure the deployment script is executable: `chmod +x deploy.sh`
2. Run the deployment script: `./deploy.sh`

### Content Synchronization

To sync content between your development machine and the Raspberry Pi:

```bash
# Push content from local to remote
./sync-content.sh -h [RASPBERRY_PI_IP] push

# Pull content from remote to local
./sync-content.sh -h [RASPBERRY_PI_IP] pull
```

## Customization

### Themes

Themes are located in `content/themes/`. To customize the theme:

1. Edit files in `content/themes/casper/` (or your chosen theme)
2. Changes will be automatically reflected in the browser

### Site Settings

1. Access the admin panel at http://localhost:2368/ghost
2. Log in with your credentials
3. Navigate to Settings to modify:
   - Site title and description
   - Logo and cover image
   - Social media accounts
   - Navigation menus

## Troubleshooting

### Starting the Server

If the server doesn't start, check the logs:

```bash
# Check Ghost service status
sudo systemctl status ghost

# Check Ghost service logs
sudo journalctl -u ghost -f
```

### Database Issues

If you encounter database issues:

1. Stop the Ghost service: `sudo systemctl stop ghost`
2. Check the database file permissions: `ls -la content/data/`
3. Ensure the ghost user has write permissions to the content directory
4. Restart the service: `sudo systemctl start ghost`