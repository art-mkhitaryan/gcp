#!/bin/bash

# Define the MySQL root password (change this to your desired password)
MYSQL_ROOT_PASSWORD='${{ secrets.MYSQL_SECRET }}'

# Install MySQL Server non-interactively
echo "Installing MySQL Server..."
sudo dnf install -y mysql-server

# Start the MySQL service
sudo systemctl start mysqld

# Enable MySQL to start on boot
sudo systemctl enable mysqld

# Generate a temporary random password for the MySQL root user
TEMP_ROOT_PASSWORD=$(sudo grep 'temporary password' /var/log/mysqld.log | awk '{print $NF}')

# Set the MySQL root password non-interactively
mysql_secure_installation <<EOF
y
$TEMP_ROOT_PASSWORD
$MYSQL_ROOT_PASSWORD
$MYSQL_ROOT_PASSWORD
y
y
y
y
EOF

# Display MySQL version and status
echo "MySQL installation completed."
mysql --version
sudo systemctl status mysqld
