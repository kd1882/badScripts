#!/bin/bash

#In Flam Grav (Or spin up your firewall)

sudo apt install -y ufw
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow ssh
sudo ufw enable
sudo ufw status

