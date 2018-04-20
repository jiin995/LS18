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

#mysql -e "drop database $4;"
#mysql -e "create database $4;"
#mysql --database=$3 < /home/dump.sql

mysql -e 'create user "crisis"@"%" identified by "ciccio";'
mysql -e "grant all privileges on *.* to 'crisis'@'%';"
mysql -e "set password for 'crisis'@'%'=PASSWORD('$4');"


#mysqladmin -u crisis --password='torro!234' password "'$4'"

rm /home/dump.sql
mv /etc/mysql/mysql.cnf_bak  /etc/mysql/mysql.cnf
rm /home/set_db.sh
