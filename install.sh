#! /usr/bin/env bash


source ./common.sh
source ./vars.sh
source ./download.sh


# Check the architecture and distribution
if [ "${OSTYPE}" != "linux-gnu" ] || [ ! -f "/etc/debian_version" ]; then
  err "Invalid OS: ${OSTYPE}, Only debian and it's descendant are supported."
  exit 1;
fi


# Dependencies
read -p "Do you want to install required debian packages? [N/y] " 
if [[ $REPLY =~ ^[Yy]$ ]]; then
  sudo apt-get install wget git
fi


# Downloading the specific binary if required
gitea_download


echo $GITEA_BINFILENAME
exit 0;
