#!/bin/bash

# Backup script for Ghost blog database and content

# Exit on any error
set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Default values
BACKUP_DIR="./backups"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_NAME="ghost_backup_$TIMESTAMP"

# Create backup directory if it doesn't exist
mkdir -p "$BACKUP_DIR"

echo -e "${GREEN}Starting Ghost backup...${NC}"

# Stop Ghost service if running as systemd service
if systemctl is-active --quiet ghost; then
    echo -e "${YELLOW}Stopping Ghost service...${NC}"
    sudo systemctl stop ghost
    SERVICE_WAS_RUNNING=true
else
    SERVICE_WAS_RUNNING=false
fi

# Backup database
echo -e "${YELLOW}Backing up database...${NC}"
if [ -f "./content/data/ghost.db" ]; then
    cp "./content/data/ghost.db" "$BACKUP_DIR/${BACKUP_NAME}_database.db"
    echo -e "${GREEN}Database backed up to $BACKUP_DIR/${BACKUP_NAME}_database.db${NC}"
else
    echo -e "${RED}Database file not found!${NC}"
fi

# Backup content directory
echo -e "${YELLOW}Backing up content directory...${NC}"
tar -czf "$BACKUP_DIR/${BACKUP_NAME}_content.tar.gz" \
    --exclude="content/logs/*" \
    --exclude="content/data/*.db*" \
    content/

echo -e "${GREEN}Content directory backed up to $BACKUP_DIR/${BACKUP_NAME}_content.tar.gz${NC}"

# Restart Ghost service if it was running
if [ "$SERVICE_WAS_RUNNING" = true ]; then
    echo -e "${YELLOW}Restarting Ghost service...${NC}"
    sudo systemctl start ghost
fi

# List backups
echo -e "${YELLOW}Current backups:${NC}"
ls -lh "$BACKUP_DIR/"

echo -e "${GREEN}Backup completed successfully!${NC}"