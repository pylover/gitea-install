#! /usr/bin/env bash


HERE=`dirname "$(readlink -f "$BASH_SOURCE")"`
source ./common.sh
source ./vars.sh


if [ "${OSTYPE}" != "linux-gnu" ] || [ ! -f "/etc/debian_version" ]; then
  err "Invalid OS: ${OSTYPE}, Only debian and it's descendant are supported."
  exit 1;
fi


# read -p "? [N/y] " 
# if [[ $REPLY =~ ^[Yy]$ ]]; then
# fi


echo $GITEA_BINFILENAME
exit 0;
