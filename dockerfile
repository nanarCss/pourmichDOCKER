# Dockerfile

# Repo of apache in alpine Repo
FROM alpine:3.12

RUN apk update

# Install apache & PHP
RUN apk add apache2 && \
    apk add php7 php7-curl php7-mbstring php7-dom php7-apache2 php7-mysqli && \

# Fichier /www crée (contient les pages web) - on set les permissions
    mkdir /www && chown -R apache.www-data /www && chown -R apache:apache /etc/phpmyadmin && \

# /www/wordpress remplace /var/www/localhost/htdocs dans la conf apache2
    sed -i 's#"/var/www/localhost/htdocs"#"/www/wordpress"#g' /etc/apache2/httpd.conf && \

# Telechargement de wordpress
    wget https://wordpress.org/wordpress-5.5.1.tar.gz && \

# Décompresse le fichier puis on supprime l'archive
    tar -xzvf wordpress-5.5.1.tar.gz -C /www && rm wordpress-5.5.1.tar.gz && \
    rm -rf /var/cache/apk/* && \

# Création du fichier /www/wordpress/wp-config.php
   cp /www/wordpress/wp-config-sample.php /www/wordpress/wp-config.php && \

# Ajout de lignes dans /etc/phpmyadmin/config.inc.php = Configuration external DB
#    echo "\$i++;" >> /etc/phpmyadmin/config.inc.php && \
 #   echo "\$cfg['Servers'][\$i]['host'] = 'db';" >> /etc/phpmyadmin/config.inc.php && \
  #  echo "\$cfg['Servers'][\$i]['port'] = '3360';" >> /etc/phpmyadmin/config.inc.php && \
   # echo "\$cfg['Servers'][\$i]['socket'] = '';" >> /etc/phpmyadmin/config.inc.php && \
    #echo "\$cfg['Servers'][\$i]['connect_type'] = 'tcp';" >> /etc/phpmyadmin/config.inc.php && \
    #echo "\$cfg['Servers'][\$i]['user'] = 'root';" >> /etc/phpmyadmin/config.inc.php && \
    #echo "\$cfg['Servers'][\$i]['password'] = 'network';" >> /etc/phpmyadmin/config.inc.php && \
    #echo "\$cfg['Servers'][\$i]['extension'] = 'mysql';" >> /etc/phpmyadmin/config.inc.php && \
    #echo "\$cfg['Servers'][\$i]['compress'] = 'FALSE';" >> /etc/phpmyadmin/config.inc.php && \
    #echo "\$cfg['Servers'][\$i]['auth_type'] = 'config';" >> /etc/phpmyadmin/config.inc.php && \

# Modification configuration Wordpress pour la DB
    sed -i "s|define( 'DB_USER', 'username_here' );|define( 'DB_USER', 'root'); |g" /www/wordpress/wp-config.php && \
    sed -i "s|define( 'DB_PASSWORD', 'password_here' );|define( 'DB_PASSWORD', 'network'); |g" /www/wordpress/wp-config.php && \
    sed -i "s|define( 'DB_HOST', 'localhost' );|define( 'DB_HOST', 'db:3306'); |g" /www/wordpress/wp-config.php && \
    sed -i "s|define( 'DB_CHARSET', 'utf8' );|define( 'DB_CHARSET', 'utf8'); |g" /www/wordpress/wp-config.php && \
    sed -i "s|define( 'DB_COLLATE', '' );|define( 'DB_COLLATE', ''); |g" /www/wordpress/wp-config.php && \
    sed -i "s|define( 'DB_NAME', 'database_name_here' );|define( 'DB_NAME', 'wordpress'); |g" /www/wordpress/wp-config.php

# PORT exposés (Http et TLS/SSL)
EXPOSE 80 430

# création de volume partagé
VOLUME /www

# Permet de lancer le site
CMD ["usr/sbin/httpd","-D","FOREGROUND"]
                
