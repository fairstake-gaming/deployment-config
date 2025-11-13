#!/bin/bash

# Backend-only Deployment Script
set -e

# Configuration
DEPLOY_DIR="/var/www/fairstake-deployment"
BACKEND_DIR="$DEPLOY_DIR/backend"

# Load environment variables
source .env

echo "🚀 Starting backend deployment..."
echo "📍 Working directory: $DEPLOY_DIR"

# Navigate to deployment directory
cd $DEPLOY_DIR

# Update backend repository
echo "📦 Updating backend..."
cd $BACKEND_DIR
git fetch origin
git reset --hard origin/main
git pull origin main

# Copy deployment files
echo "📋 Copying deployment configuration..."
cd $DEPLOY_DIR
cp /var/www/deployment-config/docker-compose.yml .
cp /var/www/deployment-config/.env .

# Rebuild only backend container
echo "🔨 Rebuilding backend container..."
docker-compose stop backend
docker-compose build --no-cache backend
docker-compose up -d backend

# Cleanup
echo "🧹 Cleaning up..."
docker system prune -f

echo "✅ Backend deployment complete!"
echo "🌐 Backend should be running at: https://api.$DOMAIN_NAME"
docker-compose ps backend