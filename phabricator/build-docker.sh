#!/usr/bin/env bash

SERVICE_NAME="peihuan/phabricator"

echo "***************************************************************"
echo "            Build phabricator docker image"
echo "***************************************************************"
docker build -t ${SERVICE_NAME} context

echo "***************************************************************"
echo "            Push duobeiyun-api-crawler docker image"
echo "***************************************************************"
docker push ${SERVICE_NAME}





