# Fair Stake Bet - Deployment Configuration

## Repository Structure
```
fairstake-deployment-config/     # This repo (server configs)
├── docker-compose.yml          # Multi-service orchestration
├── nginx/nginx.conf            # Reverse proxy config
├── .env.template              # Environment variables template
├── deploy.sh                  # Deployment script
└── setup-vps.sh              # VPS initial setup

fairstake-backend/             # Your backend repo
fairstake-frontend/            # Your frontend repo
```

## Required Information

### 1. Repository URLs
- Backend repository: `https://github.com/yourusername/fairstake-backend.git`
- Frontend repository: `https://github.com/yourusername/fairstake-frontend.git`

### 2. VPS Details
- VPS IP address
- SSH username (usually `root`)
- SSH private key

### 3. Domain Configuration
- Domain name (e.g., `fairstakebet.com`)
- DNS A record pointing to VPS IP

### 4. Production Credentials
- MongoDB Atlas connection string
- Gmail app password for emails
- Cloudinary credentials (optional)
- CCPayment API keys (optional)
- Sports API key

## Setup Process

### Step 1: Create Repositories
1. Create `fairstake-deployment-config` repository
2. Push this deployment-config folder contents to it
3. Update repository URLs in `.env.template`

### Step 2: VPS Setup (One-time)
```bash
# SSH into VPS
ssh root@your-vps-ip

# Run setup script
curl -sSL https://raw.githubusercontent.com/yourusername/fairstake-deployment-config/main/setup-vps.sh | bash
```

### Step 3: Configure Environment (Secure Methods)

#### Option A: Interactive Setup (Recommended)
```bash
cd /var/www/deployment-config
chmod +x setup-env.sh
./setup-env.sh
```

#### Option B: Manual Setup
```bash
cp .env.template .env
nano .env  # Edit with your values
chmod 600 .env  # Secure permissions
```

### Step 4: Deploy
```bash
cd /var/www/deployment-config
./deploy.sh
```

### Step 5: GitHub Actions (Optional)
Add these secrets to your deployment-config repository:

**VPS Access:**
- `VPS_HOST`: Your VPS IP address
- `VPS_USERNAME`: SSH username (usually `root`)
- `VPS_SSH_KEY`: Your private SSH key

**Environment Variables:**
- `DOMAIN_NAME`: Your domain (e.g., `fairstakebet.com`)
- `BACKEND_REPO`: Backend repository URL
- `FRONTEND_REPO`: Frontend repository URL
- `MONGODB_URI`: MongoDB connection string
- `JWT_SECRET`: JWT secret key (32+ characters)
- `SPORTS_ODDS_API_KEY`: Sports API key
- `EMAIL_USER`: Your email address
- `EMAIL_PASS`: Gmail app password
- `SESSION_SECRET`: Session secret key

## Managing Multiple Applications

To deploy additional apps, create new compose files:
```bash
# Copy and modify for new app
cp docker-compose.yml docker-compose.app2.yml

# Deploy specific app
docker-compose -f docker-compose.app2.yml up -d
```

## Commands
```bash
# View logs
docker-compose logs -f

# Restart services  
docker-compose restart

# Update deployment
git pull && ./deploy.sh

# Check status
docker-compose ps
```