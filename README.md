# Space-Ghost.org - Self-Hosted Ghost Blog Setup

A complete self-hosted Ghost blog setup for space-ghost.org with development workflow and Raspberry Pi deployment.

## 🚀 Quick Start

### Prerequisites
- Docker and Docker Compose installed
- Git initialized in your project directory
- Raspberry Pi with Docker installed (for production)

### Local Development Setup

1. **Start development environment:**
   ```bash
   ./scripts/setup-dev.sh
   ```

2. **Access your blog:**
   - Blog: http://localhost:2368
   - Admin: http://localhost:2368/ghost

3. **Complete initial setup:**
   - Create admin account
   - Configure site settings
   - Activate the space-ghost theme

## 📁 Project Structure

```
space-ghost/
├── docker-compose.yml          # Development environment
├── ghost/
│   ├── config.development.json # Local config
│   ├── config.production.json  # Production config
│   └── content/
│       ├── themes/
│       │   └── space-ghost-theme/  # Custom theme
│       ├── images/             # Uploaded images
│       └── logs/              # Application logs
├── mysql/
│   └── data/                  # MySQL data
├── scripts/
│   ├── setup-dev.sh          # Development setup
│   ├── deploy.sh             # Pi deployment
│   ├── sync.sh               # Content sync
│   └── backup.sh             # Backup creation
├── nginx/                    # Production nginx config
└── backup/                   # Backup storage
```

## 🐳 Development Commands

```bash
# Start development environment
docker-compose up -d

# Stop development environment
docker-compose down

# View logs
docker-compose logs -f

# Access Ghost shell
docker-compose exec ghost /bin/bash

# Sync content with Pi
./scripts/sync.sh

# Create backup
./scripts/backup.sh

# Deploy to Pi
./scripts/deploy.sh
```

## 🍓 Raspberry Pi Deployment

### Initial Setup

1. **Set environment variables:**
   ```bash
   export PI_USER=pi
   export PI_HOST=space-ghost.local  # or IP address
   export PI_PATH=/home/pi/space-ghost
   ```

2. **Deploy to Pi:**
   ```bash
   ./scripts/deploy.sh
   ```

3. **Access on Pi:**
   - Blog: http://space-ghost.local
   - Admin: http://space-ghost.local/ghost

### SSL Setup (Optional)

1. **Generate SSL certificates:**
   ```bash
   # Using Let's Encrypt (recommended)
   sudo apt install certbot
   sudo certbot certonly --standalone -d space-ghost.org
   
   # Copy certificates to nginx/ssl/
   sudo cp /etc/letsencrypt/live/space-ghost.org/fullchain.pem nginx/ssl/cert.pem
   sudo cp /etc/letsencrypt/live/space-ghost.org/privkey.pem nginx/ssl/key.pem
   ```

2. **Restart nginx:**
   ```bash
   ssh pi@space-ghost.local 'cd space-ghost && docker-compose restart nginx'
   ```

## 🎨 Custom Theme Development

### Theme Structure

The custom theme is located at `ghost/content/themes/space-ghost-theme/`:

```
space-ghost-theme/
├── package.json          # Theme configuration
├── default.hbs          # Main template
├── index.hbs            # Homepage
├── post.hbs             # Single post
├── page.hbs             # Static page
├── assets/
│   ├── css/
│   │   ├── screen.css   # Main styles
│   │   └── dark.css     # Dark mode styles
│   ├── js/
│   │   └── main.js      # Theme JavaScript
│   └── images/          # Theme assets
└── partials/            # Reusable components
    ├── header.hbs
    ├── footer.hbs
    └── post-card.hbs
```

### Customizing the Theme

1. **Activate the theme:**
   - Go to http://localhost:2368/ghost
   - Settings → Design → Change theme
   - Select "space-ghost" theme

2. **Modify styles:**
   - Edit `assets/css/screen.css` for main styles
   - Edit `assets/css/dark.css` for dark mode
   - Changes are hot-reloaded in development

3. **Modify templates:**
   - Edit `.hbs` files for structure
   - Use Ghost handlebars helpers
   - See [Ghost theme docs](https://ghost.org/docs/themes/)

4. **Add custom JavaScript:**
   - Edit `assets/js/main.js`
   - Automatically included in all pages

### Theme Features

- **Responsive design** - Works on all devices
- **Dark mode** - Automatic based on system preference
- **Reading progress** - Shows progress on posts
- **Fast loading** - Optimized images and assets
- **SEO friendly** - Proper meta tags and structure

## 🔄 Content Syncing

### Sync Commands

```bash
# Full sync (backup + both directions)
./scripts/sync.sh

# Sync from Pi to local
./scripts/sync.sh from-pi

# Sync from local to Pi
./scripts/sync.sh to-pi

# Create backup only
./scripts/sync.sh backup

# Check sync status
./scripts/sync.sh status
```

### What Gets Synced

- **Posts and pages** - All content
- **Images** - Uploaded media
- **Themes** - Custom theme files
- **Settings** - Site configuration
- **Navigation** - Menu structure

### Sync Best Practices

1. **Always backup before syncing:**
   ```bash
   ./scripts/backup.sh
   ```

2. **Work locally, deploy to Pi:**
   - Make changes locally
   - Test thoroughly
   - Sync to Pi when ready

3. **Regular backups:**
   ```bash
   # Add to crontab for daily backups
   0 2 * * * /path/to/space-ghost/scripts/backup.sh
   ```

## 💾 Backup and Restore

### Creating Backups

```bash
# Manual backup
./scripts/backup.sh

# Backup includes:
# - Local content and config
# - Pi content and database
# - Compressed archive
```

### Restoring from Backup

```bash
# Extract backup
tar -xzf backup/20240101_120000.tar.gz

# Restore content
rsync -av backup/20240101_120000/content_local/ ghost/content/

# Restore database (on Pi)
scp backup/20240101_120000/database.sql pi@space-ghost.local:/tmp/
ssh pi@space-ghost.local 'cd space-ghost && docker-compose exec -T db mysql -u ghost -pghostdbpass ghost < /tmp/database.sql'
```

## 🔧 Configuration

### Environment Variables

Set these in your shell or `.env` file:

```bash
# Pi connection settings
export PI_USER=pi
export PI_HOST=space-ghost.local
export PI_PATH=/home/pi/space-ghost

# Optional: Custom ports
export GHOST_PORT=2368
export MYSQL_PORT=3306
```

### Site Configuration

Edit these files for customization:

- `ghost/config.development.json` - Local settings
- `ghost/config.production.json` - Production settings
- `docker-compose.yml` - Development services
- `docker-compose.prod.yml` - Production services

## 🛠️ Development Workflow

### 1. Local Development
```bash
# Start development
docker-compose up -d

# Make changes to theme/content
# Test at http://localhost:2368
```

### 2. Sync to Pi
```bash
# Sync changes
./scripts/sync.sh to-pi

# Test on Pi
# Visit http://space-ghost.local
```

### 3. Production Updates
```bash
# Update production
./scripts/deploy.sh

# Monitor logs
ssh pi@space-ghost.local 'cd space-ghost && docker-compose logs -f'
```

## 📊 Monitoring and Maintenance

### Health Checks

```bash
# Check Ghost status
curl -f http://localhost:2368/ghost/api/admin/site/ || echo "Ghost down"

# Check Pi status
ssh pi@space-ghost.local 'docker-compose ps'
```

### Log Management

```bash
# View logs
docker-compose logs -f ghost
docker-compose logs -f db

# Clear old logs
docker-compose logs --tail=100 ghost > ghost/logs/ghost.log
```

### Updates

```bash
# Update Ghost image
docker-compose pull ghost
docker-compose up -d

# Update theme dependencies
cd ghost/content/themes/space-ghost-theme
npm update
```

## 🚨 Troubleshooting

### Common Issues

1. **Ghost won't start:**
   ```bash
   # Check logs
   docker-compose logs ghost
   
   # Check database
   docker-compose logs db
   ```

2. **Theme not loading:**
   - Ensure theme is in `ghost/content/themes/`
   - Restart Ghost: `docker-compose restart ghost`
   - Check theme package.json syntax

3. **Sync issues:**
   - Check SSH connectivity: `ssh pi@space-ghost.local`
   - Verify file permissions: `ls -la ghost/content/`
   - Check disk space: `df -h`

4. **Database connection issues:**
   ```bash
   # Check MySQL
   docker-compose exec db mysql -u ghost -pghostdbpass -e "SELECT 1"
   ```

### Getting Help

- [Ghost Documentation](https://ghost.org/docs/)
- [Ghost Theme Docs](https://ghost.org/docs/themes/)
- [Docker Documentation](https://docs.docker.com/)
- Check logs: `docker-compose logs -f`

## 🎯 Next Steps

1. **Customize your theme** - Edit `assets/css/screen.css`
2. **Add custom pages** - Create new `.hbs` files
3. **Set up email** - Configure mail settings in Ghost admin
4. **Add analytics** - Integrate Google Analytics or similar
5. **Optimize performance** - Enable caching, CDN
6. **Set up monitoring** - Add health checks and alerts

## 📞 Support

For issues or questions:
1. Check the troubleshooting section above
2. Review logs: `docker-compose logs -f`
3. Check Ghost documentation
4. Create an issue in the project repository