#!/bin/bash

# VPS Initial Setup Script
set -e

echo "🔧 Setting up VPS for Fair Stake Bet deployment..."

# Update system
apt update && apt upgrade -y

# Install Docker
if ! command -v docker &> /dev/null; then
    echo "📦 Installing Docker..."
    curl -fsSL https://get.docker.com -o get-docker.sh
    sh get-docker.sh
    systemctl start docker
    systemctl enable docker
    rm get-docker.sh
fi

# Install Docker Compose
if ! command -v docker-compose &> /dev/null; then
    echo "📦 Installing Docker Compose..."
    curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
fi

# Install Git
apt install -y git

# Create deployment directory
mkdir -p /var/www/deployment-config
cd /var/www

# Clone deployment config repository
echo "📥 Cloning deployment configuration..."
git clone https://github.com/yourusername/fairstake-deployment-config.git deployment-config

# Setup environment
cd deployment-config
cp .env.template .env

echo "✅ VPS setup complete!"
echo "📝 Next steps:"
echo "1. Edit /var/www/deployment-config/.env with your configuration"
echo "2. Run: cd /var/www/deployment-config && ./deploy.sh"