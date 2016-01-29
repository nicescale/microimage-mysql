#!/bin/bash

set -e

export CON_NAME=mysql_t
export REG_URL=d.nicescale.com:5000
export IMAGE=mysql
export TAGS="5.5 5.5.45"
export BASE_IMAGE=microimages/alpine

docker pull $BASE_IMAGE

docker build -t microimages/$IMAGE .

#./test.sh

for t in $TAGS; do
  docker tag -f microimages/$IMAGE microimages/$IMAGE:$t
done

docker push microimages/$IMAGE
