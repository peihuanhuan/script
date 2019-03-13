#!/usr/bin/env bash

SERVICE_NAME="peihuan/local-sentinel-cluster"

echo "***************************************************************"
echo "            Build phabricator docker image"
echo "***************************************************************"
docker build -t ${SERVICE_NAME} context

echo "***************************************************************"
echo "            Push local-sentinel-cluster docker image"
echo "***************************************************************"
docker push ${SERVICE_NAME}





