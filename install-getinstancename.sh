#
# Script to install getInstanceName.py to the util directory.
# getInstanceName.py helps retrieve the instance name from the output of gcloud
#
# Expected environment variable:
#   UTIL_INSTALL_DIR: the absolute path where getInstanceName.py is installed.

UTIL_INSTALL_DIR=${UTIL_INSTALL_DIR:-/tmp}

echo "import sys
import string

if len(sys.argv) >= 2:
  index = int(sys.argv[1]);
else:
  index = 0;

input_data = string.join(sys.stdin.readlines());
data = input_data.split('\n')

print data[index];" > $UTIL_INSTALL_DIR/getInstanceName.py
