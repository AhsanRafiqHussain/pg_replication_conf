#!/bin/bash

# Stop PostgreSQL service and disable it
sudo systemctl stop postgresql
sudo systemctl disable postgresql

# Purge PostgreSQL packages
sudo apt-get purge -y postgresql-14
sudo apt-get autoremove

# Remove any residual configuration files
sudo rm -rf /etc/postgresql
sudo rm -rf /var/lib/postgresql

# Remove any remaining PostgreSQL-related files
sudo find / -iname "*postgres*" -exec rm -rf {} \;

echo "PostgreSQL and related files have been completely removed."
