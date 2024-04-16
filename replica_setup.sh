#!/bin/bash

# Update and install PostgreSQL
sudo apt update
sudo apt install -y postgresql

# Stop PostgreSQL service
sudo systemctl stop postgresql

# Remove existing PostgreSQL data directory
sudo rm -rv /var/lib/postgresql/*/main/

#Get master IP from pg_hba.conf
read -p "Enter the IP address of the Master server: " MASTER_IP

# Perform base backup from master
sudo pg_basebackup -h $MASTER_IP -U replica_user -X stream -C -S replica_1 -v -R -W -D /var/lib/postgresql/*/main/

# Change ownership of PostgreSQL data directory
sudo chown -R postgres:postgres /var/lib/postgresql/*/main/

# Start PostgreSQL service
sudo systemctl start postgresql

echo "Slave setup completed successfully."
