#!/bin/bash

# Frontend-only Deployment Script
set -e

# Configuration
DEPLOY_DIR="/var/www/fairstake-deployment"
FRONTEND_DIR="$DEPLOY_DIR/frontend"

# Load environment variables
source .env

echo "🚀 Starting frontend deployment..."
echo "📍 Working directory: $DEPLOY_DIR"

# Navigate to deployment directory
cd $DEPLOY_DIR

# Update frontend repository
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

# Rebuild only frontend container
echo "🔨 Rebuilding frontend container..."
docker-compose stop frontend
docker-compose build --no-cache frontend
docker-compose up -d frontend

# Cleanup
echo "🧹 Cleaning up..."
docker system prune -f

echo "✅ Frontend deployment complete!"
echo "🌐 Frontend should be running at: https://$DOMAIN_NAME"
docker-compose ps frontend