#!/bin/bash

# Update cache and upgrade installed software on system
apt-get update
apt-get upgrade -y

# Install web server and Python
apt-get install -y apache2 python3 python3-pip python3-flask

# Configure new start page in Apache2 web server
echo "<h1>It is my $(hostname) web server</h1>" > /var/www/html/index.html

# Install Python Flask application in /app folder
cd /
git clone https://github.com/Azure-Samples/msdocs-python-flask-webapp-quickstart app
cd /app

# Run flask application
flask run --host=0.0.0.0 &
