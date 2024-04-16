#!/bin/bash

# Update and install PostgreSQL
sudo apt update
sudo apt install -y postgresql

# Stop PostgreSQL service
sudo systemctl stop postgresql

# Remove existing PostgreSQL data directory
sudo rm -rv /var/lib/postgresql/*/main/

# Function to get master IP from pg_hba.conf
get_master_ip() {
    MASTER_IP=$(sudo awk '/host\s+replication\s+replica_user/ {print $1}' /etc/postgresql/*/main/pg_hba.conf | cut -d'/' -f1)
    echo "$MASTER_IP"
}

# Get master IP address
MASTER_IP=$(get_master_ip)

if [ -z "$MASTER_IP" ]; then
    echo "Error: Master IP not found. Make sure the master server is properly configured."
    exit 1
fi

# Perform base backup from master
sudo pg_basebackup -h $MASTER_IP -U replica_user -X stream -C -S replica_1 -v -R -W -D /var/lib/postgresql/*/main/

# Change ownership of PostgreSQL data directory
sudo chown -R postgres:postgres /var/lib/postgresql/*/main/

# Start PostgreSQL service
sudo systemctl start postgresql

echo "Slave setup completed successfully."
