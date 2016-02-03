#!/bin/bash

set -xe

PASSWORD=rews8Ds
docker rm -f "$CON_NAME" > /dev/null 2>&1 || true
docker run -d --name $CON_NAME -e MYSQL_ROOT_PASSWORD=$PASSWORD $IMAGE

sleep 10

docker exec $CON_NAME mysql -e "show databases" -p$PASSWORD

docker rm -f $CON_NAME

echo "---> The test pass"
