#!/bin/bash

docker-compose down
docker volume rm wp_dbdata
docker volume rm wp_wordpress-data
docker volume rm wp_apache-available
docker volume rm wp_apache-enabled
docker volume rm wp_apache-ssl
