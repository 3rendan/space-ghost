# Space-Ghost.org Project Summary

## Project Overview
This is a self-hosted Ghost blog designed to run on a Raspberry Pi with full development and deployment capabilities.

## Directory Structure
```
space-ghost/
├── ghost-blog/                    # Main Ghost installation
│   ├── content/                   # Content directory
│   │   ├── apps/                  # Custom apps
│   │   ├── data/                  # Database files
│   │   ├── images/                # Uploaded images
│   │   ├── logs/                  # Log files
│   │   ├── settings/              # Settings files
│   │   └── themes/                # Theme files
│   ├── backups/                   # Backup directory (created after first backup)
│   ├── node_modules/              # Node.js dependencies
│   ├── config.development.json    # Development configuration
│   ├── start.js                   # Main startup script
│   ├── index.js                   # Legacy entry point
│   ├── deploy.sh                  # Raspberry Pi deployment script
│   ├── sync-content.sh            # Content synchronization script
│   ├── backup.sh                  # Backup script
│   ├── package.json               # Node.js package file
│   ├── package-lock.json          # Node.js dependency lock file
│   ├── .gitignore                 # Git ignore file
│   └── README.md                  # Project documentation
├── SETUP_PLAN.md                  # Setup plan and documentation
├── NEXT_STEPS.md                  # Next steps guide
├── PROJECT_SUMMARY.md             # This file
└── .git/                          # Git repository
```

## Key Features

### 1. Local Development
- Full Ghost development environment
- Node.js v22.21.1 compatibility
- SQLite database for easy development
- Hot reload for theme development

### 2. Deployment Ready
- Automated deployment script for Raspberry Pi
- Systemd service configuration
- nginx reverse proxy setup
- Production-ready configuration

### 3. Content Management
- Content synchronization between environments
- Automated backup scripts
- Database migration tools
- Image and media management

### 4. Customization
- Theme customization capabilities
- Custom app support
- API access for extensions
- Settings management

## Scripts and Tools

### Development
- `npm start` - Start the development server
- `npm run dev` - Start the development server (alias)

### Deployment
- `deploy.sh` - Deploy to Raspberry Pi
- `sync-content.sh` - Sync content between environments
- `backup.sh` - Create backups of content and database

### Management
- `sudo systemctl start ghost` - Start Ghost service
- `sudo systemctl stop ghost` - Stop Ghost service
- `sudo systemctl status ghost` - Check Ghost service status
- `sudo journalctl -u ghost -f` - View Ghost logs

## Configuration Files

### config.development.json
Main configuration file for development environment:
- Database settings (SQLite)
- Server settings (host, port)
- URL configuration
- Logging settings

### Systemd Service
Location: `/etc/systemd/system/ghost.service`
- Service configuration for automatic startup
- User and group settings
- Working directory
- Executable path

### nginx Configuration
Location: `/etc/nginx/sites-available/space-ghost.org`
- Reverse proxy settings
- Domain configuration
- Security headers

## Customization Points

### Themes
Location: `content/themes/`
- Casper theme (default)
- Custom theme development
- Theme activation through admin panel

### Apps
Location: `content/apps/`
- Custom app development
- Third-party app installation
- App management through admin panel

### Settings
Location: `content/settings/`
- Route configurations
- Custom settings
- Integration configurations

## Data Management

### Database
- SQLite database (`content/data/ghost.db`)
- Automatic migration on startup
- Backup capabilities

### Media
- Image uploads (`content/images/`)
- Media optimization settings
- Storage management

### Logs
- Application logs (`content/logs/`)
- Error tracking
- Performance monitoring

## Security Considerations

### File Permissions
- Proper user/group ownership
- Restricted access to sensitive files
- Secure database permissions

### Network Security
- Firewall configuration
- SSL/TLS encryption
- Secure headers in nginx

### Application Security
- Regular updates
- Security patches
- Input validation

## Performance Optimization

### Caching
- Built-in Ghost caching
- nginx caching configuration
- CDN integration options

### Database
- SQLite optimization
- Query optimization
- Index management

### Assets
- Image optimization
- CSS/JS minification
- Compression settings