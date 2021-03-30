# **************************************************************************** #
#                                                                              #
#                                                         ::::::::             #
#    Dockerfile                                         :+:    :+:             #
#                                                      +:+                     #
#    By: anspirga <anspirga@student.codam.nl>         +#+                      #
#                                                    +#+                       #
#    Created: 2021/03/23 14:31:51 by anspirga      #+#    #+#                  #
#    Updated: 2021/03/30 18:24:18 by anspirga      ########   odam.nl          #
#                                                                              #
# **************************************************************************** #

#how to install nginx with docker

#installing debian buster
From debian:buster

#make sure software packages are updated
RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get -y install wget

#install nginx
RUN apt-get -y install nginx

# run this command to run docker:
# docker build -t nginx . //build image first
# docker run -it --rm -p 80:80 nginx //then run the container with port 80:80, rm will remove container automatically after quitting
# cd /etc/nginx/sites-available# cat default

#install Maria DB
RUN apt-get -y install mariadb-server

# mysql database setup (create wordpress database)
RUN		service	mysql start; \
		echo "CREATE DATABASE wordpress;" | mysql -u root; \
		echo "GRANT ALL PRIVILEGES ON wordpress.* TO 'user'@'localhost' IDENTIFIED BY 'password';" | mysql -u root; \
		echo "FLUSH PRIVILEGES;" | mysql -u root

# MySQL config explanation
#
# CREATE DATABASE wordpress;
# => it’s just simply creating schema named with ‘wordpress’.
# 2. GRANT ALL PRIVILEGES ON ‘Schema name’.’table name’ TO ‘account name’@’host’ identified by ‘account password’ WITH GRANT OPTION;
# => Making account which can access to certain schema. In our case, we are making root account which can access to all tables in wordpress schema.
#    And we skipped password by using mysql -u root — skip-password option from MySQL Docs.
# 3. FLUSH PRIVILEGES;
# => If using INSERT, UPDATE, or DELETE statements, you should tell the server to reload the grant tables, perform a flush-privileges operation.
#    Look for this MySQL documentation and stackoverflow link.
# 4. update mysql.user set plugin=’’ where user=’root’;
# => Start from MySQL Server 5.7, if we do not provide a password to root user during the installation, it will use auth_socket plugin for authentication.
#    With this configuration, MySQL won’t care about your input password,
#    it will check the user is connecting using a UNIX socket and then compares the username.
#    But it matters when login to mysql root from other normal linux user account. That ‘s why we add this line. If you do not add this, the result page will be look like this.

#check if configuration worked with the following commands:
# service mysql start
# mysql
# show databases;
# -> wordpress should show up

#install php
RUN apt-get -y install php7.3 php-mysql php-fpm php-pdo php-gd php-cli php-mbstring


#install phpmyadmin
# but unzip it in the /var/www/html/ directory,
# because that's where web server finds files for web pages when requests come from clients/ web browser
WORKDIR /var/www/html/
RUN wget https://files.phpmyadmin.net/phpMyAdmin/5.0.1/phpMyAdmin-5.0.1-english.tar.gz
RUN tar -xf phpMyAdmin-5.0.1-english.tar.gz && rm -rf phpMyAdmin-5.0.1-english.tar.gz
RUN mv phpMyAdmin-5.0.1-english phpmyadmin

#cat and copy config.sample.inc.php into new file in VS Code and config this file
#change blow_fish_secret into some random string and numbers
#change AllowNoPassword into true

#copy changed config file into phpmyadmin folder
COPY ./config.inc.php phpmyadmin

#install wordpress
RUN wget https://wordpress.org/latest.tar.gz
RUN tar -xvzf latest.tar.gz && rm -rf latest.tar.gz

#cat and copy wp-config.php into new file in VS Code and config this file
# change DB_NAME, DB_USER and DB_PASSWORD
# copy changed config file into wordpress folder or /var/www/html?
COPY ./wp-config.php /var/www/html


#change authorization and Init bash -> Hä???
RUN chown -R www-data:www-data *
RUN chmod -R 755 /var/www/*
COPY ./srcs/init.sh ./
CMD bash init.sh

#What is this for?
CMD service nginx start; \
	service nginx status; \
	bash

# run these commands to build docker image and run container:
# docker build -t nginx . //build image first
# docker run -it --rm -p 80:80 nginx //then run the container with port 80:80, rm will remove container automatically after quitting
#
#It will run in bash form. Since nginx does routing from default file in /etc/nginx/sites-available,
#      you’ll need to go to the directory and copy it.
#      use these commands to show default configuration, but you need o alter of course:
# cd /etc/nginx/sites-available
# cat default