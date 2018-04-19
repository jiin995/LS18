FROM wordpress

COPY ssl/ /etc/apache2/ssl/
COPY sites-available/ /etc/apache2/sites-available/
COPY sites-enabled/ /etc/apache2/sites-enabled/

RUN a2enmod ssl
