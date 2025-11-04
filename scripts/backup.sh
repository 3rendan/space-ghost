#!/bin/bash

# Space Ghost Blog Backup Script
# Creates comprehensive backups of your Ghost blog

set -e

PI_USER="${PI_USER:-pi}"
PI_HOST="${PI_HOST:-space-ghost.local}"
PI_PATH="${PI_PATH:-/home/pi/space-ghost}"
BACKUP_DIR="backup/$(date +%Y%m%d_%H%M%S)"

echo "💾 Space Ghost Backup Tool"
echo "========================="

# Create backup directory
mkdir -p "$BACKUP_DIR"

# Backup local development environment
echo "📁 Backing up local development..."
cp -r ghost/content "$BACKUP_DIR/content_local"
cp docker-compose.yml "$BACKUP_DIR/"
cp ghost/config.development.json "$BACKUP_DIR/"
cp ghost/config.production.json "$BACKUP_DIR/"

# Backup Pi production environment
echo "📁 Backing up Raspberry Pi production..."
ssh ${PI_USER}@${PI_HOST} "
    cd ${PI_PATH}
    docker-compose exec -T db mysqldump -u ghost -pghostdbpass ghost > /tmp/ghost_backup.sql
"

# Copy database backup
scp ${PI_USER}@${PI_HOST}:/tmp/ghost_backup.sql "$BACKUP_DIR/database.sql"

# Copy Pi content
rsync -avz ${PI_USER}@${PI_HOST}:${PI_PATH}/ghost/content/ "$BACKUP_DIR/content_pi/"

# Create backup manifest
cat > "$BACKUP_DIR/manifest.json" << EOF
{
  "backup_date": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "local_content_size": "$(du -sh ghost/content 2>/dev/null | cut -f1 || echo '0')",
  "pi_content_size": "$(ssh ${PI_USER}@${PI_HOST} "du -sh ${PI_PATH}/ghost/content 2>/dev/null | cut -f1" || echo '0')",
  "database_size": "$(du -sh "$BACKUP_DIR/database.sql" 2>/dev/null | cut -f1 || echo '0')",
  "pi_user": "$PI_USER",
  "pi_host": "$PI_HOST",
  "pi_path": "$PI_PATH"
}
EOF

# Create compressed archive
echo "📦 Creating compressed archive..."
tar -czf "$BACKUP_DIR.tar.gz" -C backup "$(basename "$BACKUP_DIR")"

# Clean up old backups (keep last 5)
echo "🧹 Cleaning up old backups..."
cd backup
ls -t | grep -E '^[0-9]{8}_[0-9]{6}$' | tail -n +6 | xargs rm -rf 2>/dev/null || true
ls -t | grep -E '\.tar\.gz$' | tail -n +6 | xargs rm -f 2>/dev/null || true

echo "✅ Backup complete!"
echo "📁 Backup location: $BACKUP_DIR"
echo "📦 Archive: $BACKUP_DIR.tar.gz"
echo ""
echo "🔄 To restore from backup:"
echo "   tar -xzf $BACKUP_DIR.tar.gz"
echo "   ./scripts/restore.sh $BACKUP_DIR"