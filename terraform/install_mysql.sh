#!/bin/bash

# Define the MySQL root password (change this to your desired password)
MYSQL_ROOT_PASSWORD=${data.google_secret_manager_secret_version.passwd.secret_data}
echo $MYSQL_ROOT_PASSWORD >> /var/log/install_mysql_script.log

# Install MySQL Server
dnf install -y mysql-server

# Start MySQL Service
systemctl start mysqld

# Enable MySQL Service to start on boot
systemctl enable mysqld

# Set the MySQL root password noninteractively
mysqladmin -u root password "$MYSQL_ROOT_PASSWORD"

# Restart MySQL Service
systemctl restart mysqld

# Print installation completion message
echo "MySQL Server installation is complete."
