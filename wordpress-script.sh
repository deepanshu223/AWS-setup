#!/bin/bash
DIVIDER="\n***************************************\n\n"
BASE_PATH="/var/www/html"
INSTALL_PATH=""
MYSQL_USER="root"
MYSQL_PASSWORD=""
DATABASE_NAME=""



# Check if script is being run by root
if [[ $EUID -ne 0 ]]; then
   printf "This script must be run as root!\n"
   exit 1
fi

# Welcome and instructions
printf $DIVIDER
printf "Deepanshu Wordpress install AWS Ubuntu\n"
printf $DIVIDER


# MYSQL configuration
printf $DIVIDER
printf "Create DATABASE for wordpress\n"
# Prompt to continue
while true; do
	read -p "Continue [Y/N]? " cnt1
	case $cnt1 in
		[Yy]* ) break;;
		[Nn]* ) exit;;
		* ) printf "Please answer Y or N\n";;
	esac
done
mysql -u $MYSQL_USER -p$MYSQL_PASSWORD -Bse "CREATE DATABASE $DATABASE_NAME DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;"



# MYSQL configuration
printf $DIVIDER
printf "Download and setup wordpress\n"
# Prompt to continue
while true; do
	read -p "Continue [Y/N]? " cnt1
	case $cnt1 in
		[Yy]* ) break;;
		[Nn]* ) exit;;
		* ) printf "Please answer Y or N\n";;
	esac
done

cd $BASE_PATH
# Download Wordpress
wget http://wordpress.org/latest.tar.gz

# Extract Wordpress
tar -xzvf latest.tar.gz

# Rename wordpress directory to blog
mv wordpress $INSTALL_PATH

# Change directory to blog
cd $BASE_PATH/$INSTALL_PATH

# Create a WordPress config file 
mv wp-config-sample.php wp-config.php

#set database details with perl find and replace
sed -i "s/database_name_here/$DATABASE_NAME/g" $BASE_PATH/$INSTALL_PATH/wp-config.php
sed -i "s/username_here/$MYSQL_USER/g" $BASE_PATH/$INSTALL_PATH/wp-config.php
sed -i "s/password_here/$MYSQL_PASSWORD/g" $BASE_PATH/$INSTALL_PATH/wp-config.php

#create uploads folder and set permissions
mkdir wp-content/uploads
chmod 777 wp-content/uploads
chown ubuntu:www-data -R .

#remove wp file
rm $BASE_PATH/latest.tar.gz

printf $DIVIDER
printf $DIVIDER
printf "WORDPRESS SUCCESSFULLY SETUP\n"