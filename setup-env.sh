#!/bin/bash

# Secure Environment Setup Script
set -e

ENV_FILE="/var/www/deployment-config/.env"

echo "🔐 Setting up secure environment variables..."

# Create .env file from template
cp .env.template .env

# Interactive setup
read -p "Enter your domain name: " DOMAIN_NAME
read -p "Enter backend repository URL: " BACKEND_REPO
read -p "Enter frontend repository URL: " FRONTEND_REPO
read -s -p "Enter MongoDB URI: " MONGODB_URI
echo
read -s -p "Enter JWT Secret (32+ chars): " JWT_SECRET
echo
read -p "Enter email address: " EMAIL_USER
read -s -p "Enter email app password: " EMAIL_PASS
echo

# Update .env file
sed -i "s|DOMAIN_NAME=.*|DOMAIN_NAME=$DOMAIN_NAME|" .env
sed -i "s|BACKEND_REPO=.*|BACKEND_REPO=$BACKEND_REPO|" .env
sed -i "s|FRONTEND_REPO=.*|FRONTEND_REPO=$FRONTEND_REPO|" .env
sed -i "s|MONGODB_URI=.*|MONGODB_URI=$MONGODB_URI|" .env
sed -i "s|JWT_SECRET=.*|JWT_SECRET=$JWT_SECRET|" .env
sed -i "s|EMAIL_USER=.*|EMAIL_USER=$EMAIL_USER|" .env
sed -i "s|EMAIL_PASS=.*|EMAIL_PASS=$EMAIL_PASS|" .env

# Update CORS and URLs
sed -i "s|yourdomain.com|$DOMAIN_NAME|g" .env

# Set secure permissions
chmod 600 .env
chown root:root .env

echo "✅ Environment configured securely!"
echo "📁 File location: $ENV_FILE"
echo "🔒 Permissions set to 600 (owner read/write only)"