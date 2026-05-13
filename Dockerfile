FROM php:8.2-apache
# Installation de l'extension PDO MySQL
RUN docker-php-ext-install pdo pdo_mysql
# Copie des fichiers dans le serveur
COPY . /var/www/html/
# Port par défaut pour Render
EXPOSE 80