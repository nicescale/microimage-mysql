#!/bin/bash

set -e

export CON_NAME=mysql_t
export REG_URL=d.nicescale.com:5000
export IMAGE=mysql
export TAGS="5.5 5.5.45"
export BASE_IMAGE=microimages/alpine

docker pull $REG_URL/$BASE_IMAGE

docker tag -f $REG_URL/$BASE_IMAGE $BASE_IMAGE

docker build -t $REG_URL/microimages/$IMAGE .

#./test.sh

for t in $TAGS; do
  docker tag $REG_URL/microimages/$IMAGE $REG_URL/microimages/$IMAGE:$t
done

docker push $REG_URL/microimages/$IMAGE
