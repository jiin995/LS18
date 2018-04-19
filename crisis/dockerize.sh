#!/bin/bash
DB_NAME="crisis"
DB_LOCAL_USER="root"
DB_LOCAL_PASS="toor"
#della nuova istanza
DB_WP_USER="myword"
DB_WP_PASS="mypass"
DB_NEW_PASS="i93dd3342248"
WP_IP=""

PWD=$(pwd)
C_DIR_NAME=$(basename "$PWD")
DB_CONTAINER="$C_DIR_NAME""_db_1"
PHP_CONTAINER="$C_DIR_NAME""_php_1"

#Dump database per portarlo nel container
#mysqldump -u $DB_LOCAL_USER  --password=$DB_LOCAL_PASS $DB_NAME > dump.sql

#Cambio Pass al DB

#mysqladmin -u root --password=$DB_PASS password $DB_NEW_PASS

#----------------------------------------------
#parte di aggiornamento compose

#--------------------------
#!/bin/sh

service apache2 stop
chmod +x set_db.sh

cp docker-compose.yml docker-compose.yml_bak

sed -i -e "s/MYSQL_USER: wordpress/MYSQL_USER: $DB_WP_USER/" docker-compose.yml
sed -i -e "s/MYSQL_PASSWORD: wordpress/MYSQL_PASSWORD: $DB_WP_PASS/" docker-compose.yml
sed -i -e "s/MYSQL_ROOT_PASSWORD: somewordpress/MYSQL_ROOT_PASSWORD: $DB_NEW_PASS/" docker-compose.yml
sed -i -e "s/WORDPRESS_DB_USER: wordpress/WORDPRESS_DB_USER: $DB_WP_USER/" docker-compose.yml
sed -i -e "s/WORDPRESS_DB_PASSWORD: wordpress/WORDPRESS_DB_PASSWORD: $DB_WP_PASS/" docker-compose.yml

cp -dr /etc/apache2/ssl/ myphp/
cp -dr /etc/apache2/sites-available/ myphp/
cp -dr /etc/apache2/sites-enabled/  myphp/

docker-compose build
docker-compose up -d
sleep 30
#preparo il container per il restore del dump e faccio il restore
docker cp set_db.sh $DB_CONTAINER:/home
docker cp dump.sql $DB_CONTAINER:/home
docker exec $DB_CONTAINER ./home/set_db.sh root $DB_NEW_PASS $DB_NAME

rm -dr myphp/ssl
rm -dr myphp/sites-available
rm -dr myphp/sites-enabled

#cp -dr /etc/apache2/sites-available/* /var/lib/docker/volumes/wp_apache-available/_data/
#cp -dr /etc/apache2/sites-enabled/*  /var/lib/docker/volumes/wp_apache-enabled/_data/
#cp -dr  /var/lib/docker/volumes/wp_apache-ssl/_data

cp -aRdfr /var/www/html/* /var/lib/docker/volumes/crisis_http-data/_data/

sed -i -e "s/localhost/db/" /var/lib/docker/volumes/crisis_http-data/_data/connect.php
docker exec $PHP_CONTAINER service apache2 reload
#mv docker-compose.yml_bak docker-compose.yml
