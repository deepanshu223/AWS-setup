#!/bin/bash
DIVIDER="\n***************************************\n\n"
SWAP_SPACE="2G" 
PHP_MEMORY="512M"
PHP_UPLOAD="50M"
MYSQL_PASSWORD=""

# Check if script is being run by root
if [[ $EUID -ne 0 ]]; then
   printf "This script must be run as root!\n"
   exit 1
fi

# Welcome and instructions
printf $DIVIDER
printf "Deepanshu LAMP server setup on AWS Ubuntu\n"
printf $DIVIDER

# Prompt to continue
while true; do
	read -p "Continue [Y/N]? " cnt1
	case $cnt1 in
		[Yy]* ) break;;
		[Nn]* ) exit;;
		* ) printf "Please answer Y or N\n";;
	esac
done

# Install and update software
printf $DIVIDER
printf "INSTALL AND UPDATE SOFTWARE\n"
printf "Now the script will update Ubuntu and install all the necessary software.\n"
printf " * You will be prompted to enter the password for the MySQL root user\n"
read -p "Please ENTER to continue "
apt-get -y update
apt-get -y upgrade

printf "INSTALL APACHE AND PHP\n"
# Prompt to continue
while true; do
	read -p "Continue [Y/N]? " cnt1
	case $cnt1 in
		[Yy]* ) break;;
		[Nn]* ) exit;;
		* ) printf "Please answer Y or N\n";;
	esac
done
apt-get -y install curl zip unzip
apt-get -y install apache2
add-apt-repository -y ppa:ondrej/php
apt update
apt-get -y install php5.6 php5.6-mcrypt php5.6-curl php5.6-mysql
apt-get -y install mysql-server


# APACHE configuration
printf $DIVIDER
printf "APACHE CONFIGURATION\n"
# Prompt to continue
while true; do
	read -p "Continue [Y/N]? " cnt1
	case $cnt1 in
		[Yy]* ) break;;
		[Nn]* ) exit;;
		* ) printf "Please answer Y or N\n";;
	esac
done
printf "Enabling Apache modules...\n"
a2enmod expires headers rewrite ssl 

if [ ! -f /etc/apache2/sites-available/000-default.conf.orig ]; then
	printf "Backing up original configuration file to /etc/apache2/000-default.conf.orig\n"
	cp /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/000-default.conf.orig
fi

printf "Adding <Directory /var/www/html> configuration for /var/www/html\n"
FIND="<\/VirtualHost>"
REPLACE="<Directory \/var\/www\/html>\n\tOptions FollowSymLinks\n\tAllowOverride all\n\tRequire all granted\n\tOrder allow,deny\n\tallow from all\n\tHeader set Access-Control-Allow-Origin \"\*\"\n\tHeader set Timing-Allow-Origin \"\*\"\n\tHeader set X-Content-Type-Options \"nosniff\"\n\tHeader unset X-Powered-By\n<\/Directory>\n\n<\/VirtualHost>\n\n"
sed -i "0,/$FIND/s/$FIND/$REPLACE/m" /etc/apache2/sites-available/000-default.conf
service apache2 reload

# PHP configuration
printf $DIVIDER
printf "PHP CONFIGURATION\n"
# Prompt to continue
while true; do
	read -p "Continue [Y/N]? " cnt1
	case $cnt1 in
		[Yy]* ) break;;
		[Nn]* ) exit;;
		* ) printf "Please answer Y or N\n";;
	esac
done

if [ ! -f /etc/php/5.6/apache2/php.ini.orig ]; then
	printf "Backing up original configuration file to /etc/apache2/000-default.conf.orig\n"
	cp /etc/php/5.6/apache2/php.ini /etc/php/5.6/apache2/php.ini.orig
fi

FIND=".*memory_limit.*"
REPLACE="memory_limit=$PHP_MEMORY"
sed -i "0,/$FIND/s/$FIND/$REPLACE/m" /etc/php/5.6/apache2/php.ini
FIND=".*upload_max_filesize.*"
REPLACE="upload_max_filesize=$PHP_UPLOAD"
sed -i "0,/$FIND/s/$FIND/$REPLACE/m" /etc/php/5.6/apache2/php.ini
FIND=".*post_max_size.*"
REPLACE="post_max_size=$PHP_UPLOAD"
sed -i "0,/$FIND/s/$FIND/$REPLACE/m" /etc/php/5.6/apache2/php.ini

service apache2 restart

# MYSQL configuration
printf $DIVIDER
printf "MYSQL CONFIGURATION\n"
# Prompt to continue
while true; do
	read -p "Continue [Y/N]? " cnt1
	case $cnt1 in
		[Yy]* ) break;;
		[Nn]* ) exit;;
		* ) printf "Please answer Y or N\n";;
	esac
done
mysql -u root -Bse "USE mysql;ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '$MYSQL_PASSWORD';FLUSH PRIVILEGES;"


# Create SWAP SPACE
printf $DIVIDER
printf "CREATING AND ACTIVATING SWAP SPACE\n"
printf "Now the script will create a swap space for Ubuntu for 2GB.\n"
while true; do
	read -p "Continue [Y/N]? " cnt1
	case $cnt1 in
		[Yy]* ) break;;
		[Nn]* ) exit;;
		* ) printf "Please answer Y or N\n";;
	esac
done

fallocate -l $SWAP_SPACE /swapfile
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
cp /etc/fstab /etc/fstab.bak
echo '/swapfile none swap sw 0 0' | tee -a /etc/fstab


printf $DIVIDER
printf $DIVIDER
printf "SERVER SUCCESSFULLY SETUP\n"
