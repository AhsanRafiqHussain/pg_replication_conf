#!/bin/bash

# Update and install PostgreSQL
sudo apt update
sudo apt install -y postgresql

# Enable and start PostgreSQL service
sudo systemctl enable postgresql
sudo systemctl start postgresql

# Create replication user
sudo -u postgres psql -c "CREATE USER replica_user WITH REPLICATION PASSWORD '123';"

# Get PostgreSQL version and append to path
PG_VERSION=$(pg_config --version | awk '{print $2}' | cut -d '.' -f 1,2)
PG_PATH="/etc/postgresql/$PG_VERSION/main"

# Configure PostgreSQL
sudo sed -i "s/#listen_addresses = 'localhost'/listen_addresses = '*'/g" $PG_PATH/postgresql.conf
sudo sed -i "s/#wal_level = replica/wal_level = logical/g" $PG_PATH/postgresql.conf
sudo sed -i "s/#wal_log_hints = off/wal_log_hints = on/g" $PG_PATH/postgresql.conf

# Add entry to pg_hba.conf for replication
read -p "Enter the IP address of the replica server: " REPLICA_IP
echo "host    replication     replica_user     $REPLICA_IP/32     md5" | sudo tee -a $PG_PATH/pg_hba.conf > /dev/null

# Restart PostgreSQL for changes to take effect
sudo systemctl restart postgresql

echo "Master setup completed successfully."
