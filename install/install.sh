#!/bin/bash
sudo apt-get update && sudo apt-get -y upgrade
sudo tasksel
sudo apt-get install php5-curl
curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer
sudo chown -R ubuntu:ubuntu /var/www/
cd /var/www/
sudo apt-get install -y git
git clone https://github.com/Nakiami/mellivora.git
cd /var/www/mellivora/include/thirdparty/composer/
composer install
cp /var/www/mellivora/include/config/config.inc.php.example /var/www/mellivora/include/config/config.inc.php
cp /var/www/mellivora/include/config/db.inc.php.example /var/www/mellivora/include/config/db.inc.php
vim /var/www/mellivora/include/config/config.inc.php
sudo chown -R www-data:www-data /var/www/mellivora/writable/
sudo cp /var/www/mellivora/install/mellivora.apache.conf /etc/apache2/sites-available/mellivora.conf
sudo vim /etc/apache2/sites-available/mellivora.conf
sudo a2dissite 000-default
sudo a2enmod ssl
sudo a2ensite mellivora
sudo service apache2 restart
echo "CREATE DATABASE mellivora CHARACTER SET utf8 COLLATE utf8_general_ci;" | mysql -u root -p
mysql mellivora -u root -p < /var/www/mellivora/install/mellivora.sql
mysql mellivora -u root -p < /var/www/mellivora/install/countries.sql
echo "GRANT ALL PRIVILEGES ON mellivora.* To 'melDbUser'@'%' IDENTIFIED BY 'melDbUserPassword';" | mysql -u root -p
vim /var/www/mellivora/include/config/db.inc.php
echo "UPDATE users SET class = 100 WHERE id = 1;" | mysql mellivora -u root -p
