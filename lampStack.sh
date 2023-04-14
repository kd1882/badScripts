#!/bin/bash

#Install a LAMP stack
sudo apt update
sudo apt install -y apache2 mysql-server php libapache2-mod-php php-mysql
sudo systemctl enable apache2
sudo systemctl start apache2

