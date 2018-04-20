FROM php:7.1-apache

COPY ssl/ /etc/apache2/ssl/
COPY sites-available/ /etc/apache2/sites-available/
COPY sites-enabled/ /etc/apache2/sites-enabled/

RUN docker-php-ext-install mysqli  && docker-php-ext-enable mysqli  

RUN a2enmod ssl
