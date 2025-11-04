#!/bin/bash

# Space Ghost Blog Development Environment Setup
# This script sets up the local development environment

echo "🚀 Setting up Space Ghost development environment..."

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed. Please install Docker first."
    exit 1
fi

# Check if Docker Compose is installed (either v1 or v2)
if ! command -v docker-compose &> /dev/null && ! docker compose version &> /dev/null; then
    echo "❌ Docker Compose is not installed. Please install Docker Compose first."
    exit 1
fi

# Create necessary directories
echo "📁 Creating directory structure..."
mkdir -p ghost/content/{themes,images,logs,data,settings,adapters,apps}
mkdir -p mysql/data
mkdir -p scripts
mkdir -p backup

# Set proper permissions
echo "🔐 Setting permissions..."
sudo chown -R $USER:$USER ghost mysql
chmod -R 755 ghost mysql

# Start the development environment
echo "🐳 Starting Ghost development environment..."
if command -v docker-compose &> /dev/null; then
    docker-compose up -d
else
    docker compose up -d
fi

# Wait for services to be ready
echo "⏳ Waiting for services to start..."
sleep 30

# Check if Ghost is running
if curl -s http://localhost:2368 > /dev/null; then
    echo "✅ Ghost is running at http://localhost:2368"
    echo "📝 Admin panel: http://localhost:2368/ghost"
    echo ""
    echo "📖 Next steps:"
    echo "1. Visit http://localhost:2368/ghost to complete setup"
    echo "2. Create your admin account"
    echo "3. Start customizing your theme"
else
    echo "❌ Ghost might not be ready yet. Check with: docker compose logs ghost"
fi

echo ""
echo "🎯 Development commands:"
echo "  Start: docker compose up -d"
echo "  Stop: docker compose down"
echo "  Logs: docker compose logs -f"
echo "  Shell: docker compose exec ghost /bin/bash"
echo "  Backup: ./scripts/backup.sh"
echo "  Deploy: ./scripts/deploy.sh"
echo "  Sync: ./scripts/sync.sh"