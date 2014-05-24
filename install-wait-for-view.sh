#
# Script to install wait-for-view.sh to the util directory.
#
# Expected environment variable:
#   UTIL_INSTALL_DIR: the absolute path where wait-for-view.sh is installed.

UTIL_INSTALL_DIR=${UTIL_INSTALL_DIR:-/tmp}

cat > $UTIL_INSTALL_DIR/wait-for-view.sh << 'EOF'
#!/bin/bash

#
# Script to wait until the Resource View has the expected number of members in it.
# It retries 60 times with 5 seconds wait in between. If it times out, -1 will be returned.
#
# Expected environment variable:
#   UTIL_INSTALL_DIR: The absolute path to which gcloud will be installed.
#   ZONE: the zone of the ResourceView
#   VIEW_NAME: the name of the ResourceView
#   MEMBER_COUNT: the number of memebers expected in the ResourceView

UTIL_INSTALL_DIR=${UTIL_INSTALL_DIR:-/tmp}

source $UTIL_INSTALL_DIR/pathfile

echo "Waiting for resourceview $VIEW_NAME to have $MEMBER_COUNT resources."

RETRY=60

SUCCESS=""
for TRY in $(seq 1 $RETRY); do
  LINES=`gcloud preview resource-views --zone=$ZONE resources --resourceview=$VIEW_NAME list | wc -l`
  if [ $LINES -ge `expr $MEMBER_COUNT` ] ; then
    SUCCESS=true
    break;
  fi
  echo "Still waiting for resourceview $VIEW_NAME to have $MEMBER_COUNT members ..." 1>&2
  sleep 5
done

if [ -z "$SUCCESS" ]; then
  echo "[ERROR] resourceview $VIEW_NAME does not have $MEMBER_COUNT members after $RETRY attempts." 1>&2
  exit -1
fi
EOF

chmod +x $UTIL_INSTALL_DIR/wait-for-view.sh
