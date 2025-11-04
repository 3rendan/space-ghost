#!/bin/bash

# Space Ghost Blog Restore Script
# Restores from backup archives

set -e

BACKUP_DIR="${1:-}"
PI_USER="${PI_USER:-pi}"
PI_HOST="${PI_HOST:-space-ghost.local}"
PI_PATH="${PI_PATH:-/home/pi/space-ghost}"

if [[ -z "$BACKUP_DIR" ]]; then
    echo "❌ Please provide backup directory"
    echo "Usage: $0 <backup_directory>"
    echo "Example: $0 backup/20240101_120000"
    exit 1
fi

if [[ ! -d "$BACKUP_DIR" ]]; then
    echo "❌ Backup directory not found: $BACKUP_DIR"
    exit 1
fi

echo "🔄 Restoring from backup: $BACKUP_DIR"

# Confirm restore
echo "⚠️  This will overwrite current content. Continue? (y/N)"
read -r response
if [[ ! "$response" =~ ^[Yy]$ ]]; then
    echo "❌ Restore cancelled"
    exit 0
fi

# Stop services
echo "🛑 Stopping services..."
docker-compose down 2>/dev/null || true
ssh ${PI_USER}@${PI_HOST} "cd ${PI_PATH} && docker-compose down" 2>/dev/null || true

# Restore local content
echo "📁 Restoring local content..."
if [[ -d "$BACKUP_DIR/content_local" ]]; then
    rsync -av "$BACKUP_DIR/content_local/" ghost/content/
fi

# Restore Pi content
echo "📁 Restoring Pi content..."
if [[ -d "$BACKUP_DIR/content_pi" ]]; then
    rsync -av "$BACKUP_DIR/content_pi/" ${PI_USER}@${PI_HOST}:${PI_PATH}/ghost/content/
fi

# Restore database
echo "🗄️  Restoring database..."
if [[ -f "$BACKUP_DIR/database.sql" ]]; then
    scp "$BACKUP_DIR/database.sql" ${PI_USER}@${PI_HOST}:/tmp/restore.sql
    ssh ${PI_USER}@${PI_HOST} "
        cd ${PI_PATH}
        docker-compose exec -T db mysql -u ghost -pghostdbpass ghost < /tmp/restore.sql
        rm /tmp/restore.sql
    "
fi

# Restore configuration
echo "⚙️  Restoring configuration..."
if [[ -f "$BACKUP_DIR/config.production.json" ]]; then
    cp "$BACKUP_DIR/config.production.json" ghost/
    scp "$BACKUP_DIR/config.production.json" ${PI_USER}@${PI_HOST}:${PI_PATH}/ghost/
fi

# Start services
echo "🚀 Starting services..."
docker-compose up -d
ssh ${PI_USER}@${PI_HOST} "cd ${PI_PATH} && docker-compose up -d"

echo "✅ Restore complete!"
echo "📍 Local: http://localhost:2368"
echo "📍 Pi: http://${PI_HOST}"

# Verify restore
sleep 10
curl -f http://localhost:2368 && echo "✅ Local restore verified"
ssh ${PI_USER}@${PI_HOST} 'curl -f http://localhost' && echo "✅ Pi restore verified"