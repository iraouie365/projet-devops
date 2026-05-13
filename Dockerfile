FROM php:8.2-apache

# Installer extensions PHP utiles pour MySQL
RUN docker-php-ext-install mysqli pdo pdo_mysql

# Activer mod_rewrite Apache
RUN a2enmod rewrite

# Copier tous les fichiers du projet vers Apache
COPY . /var/www/html/

# Donner les permissions au dossier uploads
RUN chown -R www-data:www-data /var/www/html/uploads \
    && chmod -R 755 /var/www/html/uploads

# Exposer le port Apache
EXPOSE 80