# Space-Ghost.org Project Summary

## Project Overview
This is a self-hosted blog designed to run on a Raspberry Pi with full development and deployment capabilities. Due to compatibility issues with Ghost and Node.js v22, we've provided two approaches:

1. **Ghost Installation** (ghost-blog directory) - Full Ghost implementation with some compatibility issues
2. **Simple Blog** (simple-blog directory) - Lightweight Express.js implementation that works reliably

## Directory Structure
```
space-ghost/
├── ghost-blog/                    # Main Ghost installation (compatibility issues)
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
├── simple-blog/                   # Lightweight Express.js blog (recommended)
│   ├── public/                    # Static assets
│   ├── server.js                  # Main server file
│   ├── package.json               # Node.js package file
│   └── README.md                  # Project documentation
├── SETUP_PLAN.md                  # Setup plan and documentation
├── NEXT_STEPS.md                  # Next steps guide
├── PROJECT_SUMMARY.md             # This file
└── .git/                          # Git repository
```

## Key Features

### 1. Local Development
- Full Ghost development environment (ghost-blog)
- Lightweight Express.js development environment (simple-blog)
- Node.js v22.21.1 compatibility
- SQLite database for easy development (Ghost only)
- Hot reload for theme development (Ghost only)

### 2. Deployment Ready
- Automated deployment script for Raspberry Pi
- Systemd service configuration
- nginx reverse proxy setup
- Production-ready configuration

### 3. Content Management
- Content synchronization between environments
- Automated backup scripts (Ghost only)
- Database migration tools (Ghost only)
- Image and media management (Ghost only)

### 4. Customization
- Theme customization capabilities (Ghost only)
- Custom app support (Ghost only)
- API access for extensions (Ghost only)
- Settings management (Ghost only)
- Easy HTML/CSS/JS customization (simple-blog)

## Scripts and Tools

### Development
- `npm start` - Start the development server
- `npm run dev` - Start the development server (alias)

### Deployment
- `deploy.sh` - Deploy to Raspberry Pi (Ghost only)
- `sync-content.sh` - Sync content between environments (Ghost only)
- `backup.sh` - Create backups of content and database (Ghost only)

### Management
- `sudo systemctl start ghost` - Start Ghost service (Ghost only)
- `sudo systemctl stop ghost` - Stop Ghost service (Ghost only)
- `sudo systemctl status ghost` - Check Ghost service status (Ghost only)
- `sudo journalctl -u ghost -f` - View Ghost logs (Ghost only)
- `sudo systemctl start space-ghost` - Start simple blog service (simple-blog only)
- `sudo systemctl stop space-ghost` - Stop simple blog service (simple-blog only)
- `sudo systemctl status space-ghost` - Check simple blog service status (simple-blog only)
- `sudo journalctl -u space-ghost -f` - View simple blog logs (simple-blog only)

## Configuration Files

### config.development.json (Ghost only)
Main configuration file for development environment:
- Database settings (SQLite)
- Server settings (host, port)
- URL configuration
- Logging settings

### Systemd Service
Ghost: `/etc/systemd/system/ghost.service`
Simple Blog: `/etc/systemd/system/space-ghost.service`
- Service configuration for automatic startup
- User and group settings
- Working directory
- Executable path

### nginx Configuration
Location: `/etc/nginx/sites-available/space-ghost.org`
- Reverse proxy settings
- Domain configuration
- Security headers

## Recommended Approach

Due to compatibility issues between Ghost and Node.js v22, we recommend using the **simple-blog** implementation for immediate deployment. This lightweight Express.js application provides:

1. Reliable operation on Node.js v22
2. Easy customization through HTML/CSS/JS
3. Full deployment capability to Raspberry Pi
4. Content synchronization between environments

The **ghost-blog** directory is preserved for future use when compatibility issues are resolved or when you want to migrate to a full Ghost implementation.

## Customization Points

### Themes (Ghost only)
Location: `content/themes/`
- Casper theme (default)
- Custom theme development
- Theme activation through admin panel

### Apps (Ghost only)
Location: `content/apps/`
- Custom app development
- Third-party app installation
- App management through admin panel

### Settings (Ghost only)
Location: `content/settings/`
- Route configurations
- Custom settings
- Integration configurations

### Simple Blog Customization
Location: `simple-blog/`
- HTML templates in `server.js`
- CSS styles in HTML templates
- JavaScript in `public/` directory
- Easy to modify and extend

## Migration Path

When Ghost becomes compatible with Node.js v22 or when you want to upgrade to a full Ghost implementation:

1. Use the content synchronization scripts to transfer content
2. Export any custom themes or settings
3. Deploy the ghost-blog implementation
4. Import content into the new Ghost installation

## Data Management

### Database (Ghost only)
- SQLite database (`content/data/ghost.db`)
- Automatic migration on startup
- Backup capabilities

### Media (Ghost only)
- Image uploads (`content/images/`)
- Media optimization settings
- Storage management

### Logs
- Application logs (`content/logs/`) (Ghost only)
- Error tracking
- Performance monitoring

## Security Considerations

### File Permissions
- Proper user/group ownership
- Restricted access to sensitive files
- Secure database permissions (Ghost only)

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
- Built-in Ghost caching (Ghost only)
- nginx caching configuration
- CDN integration options

### Database (Ghost only)
- SQLite optimization
- Query optimization
- Index management

### Assets
- Image optimization
- CSS/JS minification
- Compression settings