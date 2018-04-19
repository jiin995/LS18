#!/bin/bash

DB_LOCAL_USER="root"
DB_LOCAL_PASS="toor"
#della nuova istanza
DB_WP_USER="myword"
DB_WP_PASS="mypass"
DB_NEW_PASS="i93dd3342248"
WP_IP=""

#Dump database per portarlo nel container
#mysqldump -u $DB_LOCAL_USER  --password=$DB_LOCAL_PASS wordpress > wordpress_dump

#Cambio Pass al DB

#mysqladmin -u root --password=$DB_PASS password $DB_NEW_PASS

#----------------------------------------------
#parte di aggiornamento compose

#--------------------------

cp docker-compose.yml docker-compose.yml_bak

sed -i -e "s/MYSQL_USER: wordpress/MYSQL_USER: $DB_WP_USER/" docker-compose.yml
sed -i -e "s/MYSQL_PASSWORD: wordpress/MYSQL_PASSWORD: $DB_WP_PASS/" docker-compose.yml
sed -i -e "s/MYSQL_ROOT_PASSWORD: somewordpress/MYSQL_ROOT_PASSWORD: $DB_NEW_PASS/" docker-compose.yml
sed -i -e "s/WORDPRESS_DB_USER: wordpress/WORDPRESS_DB_USER: $DB_WP_USER/" docker-compose.yml
sed -i -e "s/WORDPRESS_DB_PASSWORD: wordpress/WORDPRESS_DB_PASSWORD: $DB_WP_PASS/" docker-compose.yml

docker-compose up -d
sleep 45
#preparo il container per il restore del dump e faccio il restore
docker cp set_db.sh wp_db_1:/home
docker cp wordpress_dump wp_db_1:/home
docker exec wp_db_1 ./home/set_db.sh root $DB_NEW_PASS

cp -dr /etc/apache2/sites-available /var/lib/docker/volumes/wp_apache-available/_data
cp -dr /etc/apache2/sites-enabled  /var/lib/docker/volumes/wp_apache-enabled/_data
cp -dr /etc/apache2/ssl /var/lib/docker/volumes/wp_apache-ssl/_data
cp -dr /var/www/wordpress /var/www/html

#mv docker-compose.yml_bak docker-compose.yml
