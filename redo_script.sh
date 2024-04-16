#!/bin/bash

# Stop PostgreSQL service if running
sudo systemctl stop postgresql

# Remove PostgreSQL package
sudo apt purge -y postgresql

# Remove PostgreSQL data directories
sudo rm -rf /var/lib/postgresql

# Remove PostgreSQL configuration files
sudo rm -rf /etc/postgresql

# Remove PostgreSQL user and group
sudo deluser postgres
sudo delgroup postgres

echo "PostgreSQL and related files removed successfully."
