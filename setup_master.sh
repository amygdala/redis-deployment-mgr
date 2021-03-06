#!/bin/bash

source $UTIL_INSTALL_DIR/pathfile

# REDIS_MASTER=`gcloud preview resource-views --zone=$ZONE resources --resourceview=$VIEW_NAME list -l | python $UTIL_INSTALL_DIR/getInstanceName.py `

echo requirepass $REDIS_AUTH >> /etc/redis/6379.conf
/etc/init.d/redis_6379 start
/etc/init.d/redis_26379 start
