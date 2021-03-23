# **************************************************************************** #
#                                                                              #
#                                                         ::::::::             #
#    Dockerfile                                         :+:    :+:             #
#                                                      +:+                     #
#    By: anspirga <anspirga@student.codam.nl>         +#+                      #
#                                                    +#+                       #
#    Created: 2021/03/23 14:31:51 by anspirga      #+#    #+#                  #
#    Updated: 2021/03/23 18:58:47 by anspirga      ########   odam.nl          #
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



#What is this for?
CMD service nginx start; \
	service nginx status; \
	bash

# run these commands to builld docker image and run container:
# docker build -t nginx . //build image first
# docker run -it --rm -p 80:80 nginx //then run the container with port 80:80, rm will remove container automatically after quitting
#
#It will run in bash form. Since nginx does routing from default file in /etc/nginx/sites-available,
#      you’ll need to go to the directory and copy it.
#      use these commands to show default configuration, but you need o alter of course:
# cd /etc/nginx/sites-available
# cat default