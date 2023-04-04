#!/bin/sh

# data
mkdir "/data"
mkdir "/data/www"

# log
mkdir "/data/log"
mkdir "/data/log/www"
mkdir "/data/log/apache"
mkdir "/data/log/www/app-php7"

# app
mkdir "/data/www/app-php7"
mkdir "/data/www/app-php7/log"

# drop
docker rmi -f "alpine-apache-php7"

# build
docker build --no-cache -t "alpine-apache-php7" "/data/container/alpine-apache-php7/."

# test
rm -rfv "/data/www/app-php7"
cp -rfv "/data/container/alpine-apache-php7/_app/" "/data/www/app-php7"

# drop
docker rm -f "app-php7"

# run -> app
docker run --name "app-php7" \
	-p 7001:80 \
	-v "/etc/hosts":"/etc/hosts" \
	-v "/data/log/apache/app-php7":"/var/log/apache2" \
	-v "/data/log/www/app-php7":"/data/log" \
	-v "/data/www/app-php7":"/data" \
	--restart=always \
	-d "alpine-apache-php7":"latest"

# attach
docker attach "app-php7"
docker exec -it "app-php7" "/bin/bash"

# start
docker start "app-php7"

# app

docker exec -d "app-php7" "/bin/bash" php -v

#
