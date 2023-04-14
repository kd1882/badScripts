#!/bin/bash
# Usage: ./create-mysql-db.sh dbname dbuser dbpass
DBNAME="$1"
DBUSER="$2"
DBPASS="$3"

sudo mysql -e "CREATE DATABASE $DBNAME;"
sudo mysql -e "CREATE USER '$DBUSER'@'localhost' IDENTIFIED BY '$DBPASS';"
sudo mysql -e "GRANT ALL PRIVILEGES ON $DBNAME.* TO '$DBUSER'@'localhost';"
sudo mysql -e "FLUSH PRIVILEGES;"

