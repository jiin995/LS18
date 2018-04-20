#!/bin/bash
#DB_NAME="crisis"
DB_LOCAL_USER="root"
DB_LOCAL_PASS="toor"

DB_CONTAINER_PASS="torro!234"
DB_CONTAINER_NEW_PASS="torro!234"
DB_CONTAINER_CRISIS_OLD_PASS="torro!234"
DB_CONTAINER_CRISIS_NEW_PASS="torro!234"
#della nuova istanza

PWD=$(pwd)
C_DIR_NAME=$(basename "$PWD")
DB_CONTAINER="$C_DIR_NAME""_db_1"
PHP_CONTAINER="$C_DIR_NAME""_php_1"

#Dump database per portarlo nel container
#mysqldump -u $DB_LOCAL_USER  --password=$DB_LOCAL_PASS $DB_NAME > dump.sql

#Cambio Pass al DB

#mysqladmin -u root --password=$DB_PASS password $DB_NEW_PASS


service apache2 stop
chmod +x set_db.sh

cp -dr /etc/apache2/ssl/ myphp/
cp -dr /etc/apache2/sites-available/ myphp/
cp -dr /etc/apache2/sites-enabled/  myphp/

#copio la configurazione di mysql
mkdir /var/lib/docker/volumes/crisis_dbdata/
mkdir /var/lib/docker/volumes/crisis_dbdata/_data
cp -rafd ../../Downloads/crisis.mil04.ex/mysqlvarlibfolder/mysql/* /var/lib/docker/volumes/crisis_dbdata/_data
#cp -rafd /var/lib/mysql/* /var/lib/docker/volumes/crisis_dbdata/_data



docker-compose build
docker-compose up -d
sleep 5

#preparo il container per il restore del dump e faccio il restore
docker cp set_db.sh $DB_CONTAINER:/home
docker cp dump.sql $DB_CONTAINER:/home
docker exec $DB_CONTAINER ./home/set_db.sh root $DB_CONTAINER_PASS $DB_CONTAINER_NEW_PASS $DB_CONTAINER_CRISIS_NEW_PASS

rm -dr myphp/ssl
rm -dr myphp/sites-available
rm -dr myphp/sites-enabled


cp -aRdfr /var/www/html/* /var/lib/docker/volumes/crisis_http-data/_data/

sed -i -e "s/localhost/db/" /var/lib/docker/volumes/crisis_http-data/_data/connect.php
docker exec $PHP_CONTAINER docker-php-ext-install mysqli
docker exec $PHP_CONTAINER docker-php-ext-enable mysqli

docker exec $PHP_CONTAINER service apache2 reload
#mv docker-compose.yml_bak docker-compose.yml
