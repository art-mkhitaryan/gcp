#!/bin/bash

# Define the MySQL root password (change this to your desired password)
MYSQL_ROOT_PASSWORD=$(gcloud secrets versions access latest --secret=MYSQL_ROOT_PASSWORD)
echo $MYSQL_ROOT_PASSWORD >> /var/log/install_mysql_script.log

# Install MySQL Server
yum install -y mysql-server

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
