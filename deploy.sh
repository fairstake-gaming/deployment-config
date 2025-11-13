#!/bin/bash

# Automated VPS Deployment Script
set -e

# Configuration
DEPLOY_DIR="/var/www/fairstake-deployment"
BACKEND_DIR="$DEPLOY_DIR/backend"
FRONTEND_DIR="$DEPLOY_DIR/frontend"

# Load environment variables
source .env

echo "🚀 Starting deployment..."
echo "📍 Working directory: $DEPLOY_DIR"

# Navigate to deployment directory
cd $DEPLOY_DIR

# Update repositories
echo "📦 Updating backend..."
cd $BACKEND_DIR
git fetch origin
git reset --hard origin/main
git pull origin main

echo "📦 Updating frontend..."
cd $FRONTEND_DIR
git fetch origin
git reset --hard origin/main
git pull origin main

# Copy deployment files
echo "📋 Copying deployment configuration..."
cd $DEPLOY_DIR
cp /var/www/deployment-config/docker-compose.yml .
cp /var/www/deployment-config/.env .

# Copy nginx config if it exists
if [ -f "/var/www/deployment-config/nginx/nginx.conf" ]; then
    mkdir -p nginx
    cp /var/www/deployment-config/nginx/nginx.conf nginx/
fi

# Build and deploy
echo "🔨 Building and deploying containers..."
docker-compose down --remove-orphans || true
docker-compose build --no-cache
docker-compose up -d

# Cleanup
echo "🧹 Cleaning up..."
docker system prune -f

echo "✅ Deployment complete!"
echo "🌐 Your app should be running at: https://$DOMAIN_NAME"
docker-compose ps