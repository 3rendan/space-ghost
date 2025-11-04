#!/bin/bash

# Space Ghost Blog Sync Script
# Syncs content between local development and Raspberry Pi

set -e

PI_USER="${PI_USER:-pi}"
PI_HOST="${PI_HOST:-space-ghost.local}"
PI_PATH="${PI_PATH:-/home/pi/space-ghost}"
SYNC_DIRECTION="${SYNC_DIRECTION:-both}"

echo "🔄 Space Ghost Sync Tool"
echo "========================"

# Function to sync from Pi to local
sync_from_pi() {
    echo "📥 Syncing FROM Raspberry Pi to local..."
    
    # Sync content (posts, images, themes)
    rsync -avz --progress \
        --exclude='logs/*' \
        --exclude='data/*' \
        --exclude='tmp/*' \
        ${PI_USER}@${PI_HOST}:${PI_PATH}/ghost/content/ \
        ./ghost/content/
    
    echo "✅ Sync from Pi complete"
}

# Function to sync from local to Pi
sync_to_pi() {
    echo "📤 Syncing FROM local to Raspberry Pi..."
    
    # Sync content (posts, images, themes)
    rsync -avz --progress \
        --exclude='logs/*' \
        --exclude='data/*' \
        --exclude='tmp/*' \
        --exclude='.git' \
        ./ghost/content/ \
        ${PI_USER}@${PI_HOST}:${PI_PATH}/ghost/content/
    
    # Sync configuration if changed
    rsync -avz --progress \
        ./ghost/config.production.json \
        ${PI_USER}@${PI_HOST}:${PI_PATH}/ghost/
    
    echo "✅ Sync to Pi complete"
    
    # Restart Ghost on Pi to pick up changes
    echo "🔄 Restarting Ghost on Pi..."
    ssh ${PI_USER}@${PI_HOST} "cd ${PI_PATH} && docker-compose restart ghost"
}

# Function to create backup
create_backup() {
    echo "💾 Creating backup..."
    
    BACKUP_DIR="backup/$(date +%Y%m%d_%H%M%S)"
    mkdir -p $BACKUP_DIR
    
    # Backup local content
    cp -r ghost/content $BACKUP_DIR/content_local
    
    # Backup Pi content
    rsync -avz ${PI_USER}@${PI_HOST}:${PI_PATH}/ghost/content/ $BACKUP_DIR/content_pi/
    
    echo "✅ Backup created at $BACKUP_DIR"
}

# Function to show sync status
show_status() {
    echo "📊 Sync Status"
    echo "============="
    
    echo "Local themes:"
    ls -la ghost/content/themes/ 2>/dev/null || echo "No themes found"
    
    echo ""
    echo "Pi themes:"
    ssh ${PI_USER}@${PI_HOST} "ls -la ${PI_PATH}/ghost/content/themes/" 2>/dev/null || echo "No themes found"
    
    echo ""
    echo "Local images: $(find ghost/content/images -type f 2>/dev/null | wc -l) files"
    echo "Pi images: $(ssh ${PI_USER}@${PI_HOST} "find ${PI_PATH}/ghost/content/images -type f 2>/dev/null | wc -l") files"
}

# Parse command line arguments
case "${1:-sync}" in
    "from-pi")
        sync_from_pi
        ;;
    "to-pi")
        sync_to_pi
        ;;
    "backup")
        create_backup
        ;;
    "status")
        show_status
        ;;
    "sync"|"")
        create_backup
        sync_to_pi
        sync_from_pi
        ;;
    *)
        echo "Usage: $0 [from-pi|to-pi|backup|status|sync]"
        echo ""
        echo "Commands:"
        echo "  from-pi  - Sync content from Pi to local"
        echo "  to-pi    - Sync content from local to Pi"
        echo "  backup   - Create backup of both local and Pi content"
        echo "  status   - Show sync status"
        echo "  sync     - Full sync with backup (default)"
        exit 1
        ;;
esac

echo ""
echo "🎉 Sync complete!"
echo "💡 You can set PI_USER and PI_HOST environment variables for custom connection"