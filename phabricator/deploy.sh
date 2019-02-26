#!/usr/bin/env bash

docker pull mysql:5.7
docker pull peihuan/phabricator

echo "kill old phabricator_mysql ~~~~~~~~~~~~~~~~"
docker rm -f phabricator_mysql
echo "kill old phabricator ~~~~~~~~~~~~~~~~~~~~~~"
docker rm -f phabricator

MYSQL_ROOT_PASSWORD=root
docker run -d --name phabricator_mysql \
    -e MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD} \
    mysql:5.7

# wait mysql to  accept connections
echo -n "wait for mysql server"
timeout=60
while ! docker exec phabricator_mysql mysqladmin -uroot -proot status >/dev/null 2>&1; do
    timeout=$(($timeout - 1))
    if [ $timeout -eq 0 ]; then
        echo -e "\nCould not connect to database server. Aborting..."
        exit 1
    fi
    echo -n "."
    sleep 1
done

echo

docker run -d -it --name phabricator \
    -p 81:80 \
    --link phabricator_mysql \
    -e MYSQL_HOST=phabricator_mysql \
    -e MYSQL_PASS=${MYSQL_ROOT_PASSWORD} \
    -e PHABRICATOR_DOMAIN=phabricator.example.com \
    peihuan/phabricator

