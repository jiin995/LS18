#!/bin/bash

if [ $# == 1 ] ; then
  if [ $1 != "y" ] ; then
    exit 1
  fi
else
  echo "Usalo solo se sei sicuro di voler perdere tutti i tuoi dati della web_APP"
  echo "Perderai la configurazione di Apache, tutti i dati di Wordpress e il database "
  echo "Sei sicuro di voler continuare ? [s/N]"

  CHOISE="y"
  read $CHOISE
  if [ $CHOISE != "y" ] ; then
      exit -1
    fi
fi
PWD=$(pwd)
C_DIR_NAME=$(basename "$PWD")

#define volumi da rimuovere
DB_DATA="$C_DIR_NAME""_dbdata"
WORDPRESS="$C_DIR_NAME""_wordpress-data"
APACHEA="$C_DIR_NAME""_apache-available"
APACHEE="$C_DIR_NAME""_apache-enabled"
APACHES="$C_DIR_NAME""_apache-ssl"


docker-compose down
docker volume rm $DB_DATA
docker volume rm $WORDPRESS
docker volume rm $APACHEA
docker volume rm $APACHEE
docker volume rm $APACHES
