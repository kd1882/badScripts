#!/bin/bash
# Usage: ./create-vhost.sh domain-name
# Needs some configuring and TLC to work
DOMAIN="$1"

sudo cp /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/"$DOMAIN".conf

sudo sed -i "s|ServerAdmin webmaster@localhost|ServerAdmin webmaster@$DOMAIN|" /etc/apache2/sites-available/"$DOMAIN".conf
sudo sed -i "s|ServerName localhost|ServerName $DOMAIN|" /etc/apache2/sites-available/"$DOMAIN".conf
sudo sed -i "s|DocumentRoot /var/www/html|DocumentRoot /var/www/$DOMAIN|" /etc/apache2/sites-available/"$DOMAIN".conf

sudo mkdir -p /var/www/"$DOMAIN"
sudo chown -R $USER:$USER /var/www/"$DOMAIN"
sudo chmod -R 755 /var/www/"$DOMAIN"

sudo a2ensite "$DOMAIN"
sudo systemctl reload apache2

