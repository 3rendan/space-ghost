#!/bin/bash

# Content synchronization script for Ghost blog
# This script helps sync content between development and production environments

# Exit on any error
set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Default values
REMOTE_HOST=""
REMOTE_USER="pi"
REMOTE_PATH="/var/www/space-ghost"
ACTION=""

# Help function
show_help() {
    echo "Usage: $0 [OPTIONS] [push|pull]"
    echo ""
    echo "Options:"
    echo "  -h, --host HOST     Remote host (IP or domain)"
    echo "  -u, --user USER     Remote user (default: pi)"
    echo "  -p, --path PATH     Remote path (default: /var/www/space-ghost)"
    echo "  -H, --help          Show this help message"
    echo ""
    echo "Actions:"
    echo "  push                Push content from local to remote"
    echo "  pull                Pull content from remote to local"
    echo ""
    echo "Examples:"
    echo "  $0 -h 192.168.1.100 push    # Push content to Raspberry Pi"
    echo "  $0 -h mydomain.com pull     # Pull content from production"
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--host)
            REMOTE_HOST="$2"
            shift 2
            ;;
        -u|--user)
            REMOTE_USER="$2"
            shift 2
            ;;
        -p|--path)
            REMOTE_PATH="$2"
            shift 2
            ;;
        -H|--help)
            show_help
            exit 0
            ;;
        push|pull)
            ACTION="$1"
            shift
            ;;
        *)
            echo -e "${RED}Unknown option: $1${NC}"
            show_help
            exit 1
            ;;
    esac
done

# Check if action is provided
if [ -z "$ACTION" ]; then
    echo -e "${RED}Error: Action (push or pull) is required${NC}"
    show_help
    exit 1
fi

# Check if remote host is provided
if [ -z "$REMOTE_HOST" ]; then
    echo -e "${RED}Error: Remote host is required${NC}"
    show_help
    exit 1
fi

# Check if rsync is installed
if ! command -v rsync &> /dev/null; then
    echo -e "${RED}Error: rsync is not installed${NC}"
    exit 1
fi

# Check if SSH connection works
echo -e "${YELLOW}Testing SSH connection to $REMOTE_USER@$REMOTE_HOST...${NC}"
if ! ssh -q $REMOTE_USER@$REMOTE_HOST "echo 'SSH connection successful'"; then
    echo -e "${RED}Error: Cannot establish SSH connection to $REMOTE_USER@$REMOTE_HOST${NC}"
    exit 1
fi

# Define content directories to sync
CONTENT_DIRS=(
    "content/images"
    "content/data"
    "content/settings"
)

echo -e "${GREEN}Starting content synchronization...${NC}"
echo -e "${YELLOW}Action: $ACTION${NC}"
echo -e "${YELLOW}Remote: $REMOTE_USER@$REMOTE_HOST:$REMOTE_PATH${NC}"

# Stop Ghost on remote server before sync
if [ "$ACTION" == "push" ]; then
    echo -e "${YELLOW}Stopping Ghost service on remote server...${NC}"
    ssh $REMOTE_USER@$REMOTE_HOST "sudo systemctl stop ghost" || true
fi

# Sync content directories
for dir in "${CONTENT_DIRS[@]}"; do
    echo -e "${YELLOW}Syncing $dir...${NC}"
    
    if [ "$ACTION" == "push" ]; then
        # Create directory on remote if it doesn't exist
        ssh $REMOTE_USER@$REMOTE_HOST "mkdir -p $REMOTE_PATH/$dir"
        
        # Sync from local to remote
        rsync -avz --delete \
            --exclude '*.log' \
            --exclude 'ghost-dev.db' \
            "./$dir/" \
            "$REMOTE_USER@$REMOTE_HOST:$REMOTE_PATH/$dir/"
    else
        # Create directory locally if it doesn't exist
        mkdir -p "./$dir"
        
        # Sync from remote to local
        rsync -avz --delete \
            --exclude '*.log' \
            --exclude 'ghost-dev.db' \
            "$REMOTE_USER@$REMOTE_HOST:$REMOTE_PATH/$dir/" \
            "./$dir/"
    fi
done

# Restart Ghost on remote server after sync
if [ "$ACTION" == "push" ]; then
    echo -e "${YELLOW}Starting Ghost service on remote server...${NC}"
    ssh $REMOTE_USER@$REMOTE_HOST "sudo systemctl start ghost" || true
fi

echo -e "${GREEN}Content synchronization completed successfully!${NC}"