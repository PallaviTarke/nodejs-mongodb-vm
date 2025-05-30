#!/bin/bash
   VM_IP=$1
   ssh -o StrictHostKeyChecking=no -i ~/.ssh/gcp-key user@$VM_IP << 'EOF'
     sudo mkdir -p /app
     sudo chown user:user /app
   EOF
   scp -i ~/.ssh/gcp-key docker-compose.yml user@$VM_IP:/app/docker-compose.yml
   scp -i ~/.ssh/gcp-key prometheus.yml user@$VM_IP:/app/prometheus.yml
   ssh -o StrictHostKeyChecking=no -i ~/.ssh/gcp-key user@$VM_IP << 'EOF'
     cd /app
     export COMPOSE_PROJECT_NAME=nodejs-mongodb
     docker-compose pull
     docker-compose up -d
   EOF

