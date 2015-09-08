FROM sys42/docker-nginx-php-fpm:1.1.0

RUN set -x \
 && cd /tmp \
 && curl http://download.dokuwiki.org/src/dokuwiki/dokuwiki-stable.tgz > tmp.tgz \
 && tar xzf tmp.tgz \
 && rm -rf /usr/share/nginx/html \
 && mv dokuwiki* /usr/share/nginx/html \
 && chown -R www-data:www-data /usr/share/nginx/html \
 && rm tmp.tgz

COPY site-config /etc/nginx/sites-available/default
