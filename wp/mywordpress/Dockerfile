FROM wordpress:4.9-php5.6

COPY ssl/ /etc/apache2/ssl/
COPY sites-available/ /etc/apache2/sites-available/
COPY sites-enabled/ /etc/apache2/sites-enabled/

RUN a2enmod ssl
