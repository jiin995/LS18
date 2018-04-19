#!/bin/bash

#aggiungo info di accesso mysql
cp /etc/mysql/mysql.cnf  /etc/mysql/mysql.cnf_bak
  echo "[mysqldump]" >> /etc/mysql/mysql.cnf
  echo "user=$1" >> /etc/mysql/mysql.cnf
  echo "password=$2" >> /etc/mysql/mysql.cnf
  echo "[mysql]" >> /etc/mysql/mysql.cnf
  echo "user=$1" >> /etc/mysql/mysql.cnf
  echo "password=$2" >> /etc/mysql/mysql.cnf
  echo "[mysqladmin]" >> /etc/mysql/mysql.cnf
  echo "user=$1" >> /etc/mysql/mysql.cnf
  echo "password=$2" >> /etc/mysql/mysql.cnf

#se deve essere cambiato ip/dominio di wp
#	sed -i "s/172.17.0.3/$IP/g" wordpress_dump

mysql -e "drop database wordpress;"
mysql -e "create database wordpress;"
mysql --database=wordpress < /home/wordpress_dump

rm /home/wordpress_dump
mv /etc/mysql/mysql.cnf_bak  /etc/mysql/mysql.cnf
rm /home/set_db.sh
