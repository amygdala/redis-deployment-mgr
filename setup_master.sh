#!/bin/bash

source $UTIL_INSTALL_DIR/pathfile

REDIS_MASTER=`gcloud preview resource-views --zone=$ZONE resources --resourceview=$VIEW_NAME list -l | python $UTIL_INSTALL_DIR/getInstanceName.py `

echo slaveof $REDIS_MASTER 6379 >> /tmp/amy_master_redis.conf
