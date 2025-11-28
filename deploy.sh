#!/bin/bash

# VPS Configuration
VPS_HOST="lab0172.236.230.200"
VPS_USER="root"  # Change this to your VPS username
VPS_PATH="/var/www/portal"  # Change this to your desired path on VPS

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Deploying PORTALshop to VPS...${NC}"

# Create directory on VPS if it doesn't exist
ssh ${VPS_USER}@${VPS_HOST} "mkdir -p ${VPS_PATH}"

# Sync files to VPS
rsync -avz --delete \
  --exclude 'deploy.sh' \
  --exclude 'README.md' \
  --exclude '.git' \
  --exclude '.DS_Store' \
  ./ ${VPS_USER}@${VPS_HOST}:${VPS_PATH}/

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Deployment successful!${NC}"
    echo -e "${GREEN}✓ Your site is now at: http://${VPS_HOST}${NC}"
else
    echo -e "${YELLOW}✗ Deployment failed${NC}"
    exit 1
fi
