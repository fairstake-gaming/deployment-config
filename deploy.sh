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

# Create deployment directory
mkdir -p $DEPLOY_DIR
cd $DEPLOY_DIR

# Clone/Update repositories
if [ -d "$BACKEND_DIR" ]; then
    echo "📦 Updating backend..."
    cd $BACKEND_DIR && git pull origin main
else
    echo "📦 Cloning backend..."
    git clone $BACKEND_REPO $BACKEND_DIR
fi

if [ -d "$FRONTEND_DIR" ]; then
    echo "📦 Updating frontend..."
    cd $FRONTEND_DIR && git pull origin main
else
    echo "📦 Cloning frontend..."
    git clone $FRONTEND_REPO $FRONTEND_DIR
fi

# Copy deployment files
cd $DEPLOY_DIR
cp /var/www/deployment-config/docker-compose.yml .
cp /var/www/deployment-config/nginx/nginx.conf nginx.conf
cp /var/www/deployment-config/.env .

# Replace domain in nginx config
sed -i "s/\${DOMAIN_NAME}/$DOMAIN_NAME/g" nginx.conf

# Build and deploy
echo "🔨 Building and deploying..."
docker-compose down --remove-orphans
docker-compose build --no-cache
docker-compose up -d

# Cleanup
docker system prune -f

echo "✅ Deployment complete!"
echo "🌐 Your app is running at: http://$DOMAIN_NAME"