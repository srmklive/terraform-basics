#!/bin/bash

sudo apt-get update

sudo DEBIAN_FRONTEND=noninteractive NEEDRESTART_SUSPEND=1 apt-get install -y mysql-server

password=$(cat /home/ubuntu/mysql_root_password)

echo "The MySQL root password is: $password"

echo "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '$password';" | sudo mysql