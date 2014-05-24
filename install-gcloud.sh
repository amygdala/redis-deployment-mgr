#
# Script to install gcloud tool.
#
# Expected environment variables:
#   UTIL_INSTALL_DIR: The absolute path to which gcloud will be installed.

UTIL_INSTALL_DIR=${UTIL_INSTALL_DIR:-/tmp}

wget https://dl.google.com/dl/cloudsdk/release/google-cloud-sdk.tar.gz -O $UTIL_INSTALL_DIR/google-cloud-sdk.tar.gz

cd $UTIL_INSTALL_DIR

tar xvf google-cloud-sdk.tar.gz

$UTIL_INSTALL_DIR/google-cloud-sdk/install.sh --usage-reporting false --disable-installation-options --rc-path $UTIL_INSTALL_DIR/pathfile --bash-completion true --path-update true

source $UTIL_INSTALL_DIR/pathfile

gcloud --quiet components update preview
