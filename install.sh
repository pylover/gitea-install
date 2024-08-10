#! /usr/bin/env bash


source ./common.sh
source ./vars.sh
source ./download.sh


# Check the architecture and distribution
if [ "${OSTYPE}" != "linux-gnu" ] || [ ! -f "/etc/debian_version" ]; then
  err "Invalid OS: ${OSTYPE}, Only debian and it's descendant are supported."
  exit 1;
fi


# Check the privileges
if [ "$(whoami)" != "root" ]; then
  err "Please run this script as root"
fi


# Dependencies
read -p "Do you want to install required debian packages? [N/y] " 
if [[ $REPLY =~ ^[Yy]$ ]]; then
  apt-get install wget git
fi


# Downloading the specific binary if required
gitea_download


# Create the git user
adduser \
   --system \
   --shell /bin/bash \
   --gecos 'Git Version Control' \
   --group \
   --disabled-password \
   --home /home/git \
   git


# Create required directory structure
# TODO: /etc/gitea is temporarily set with write permissions for user git so 
# that the web installer can write the configuration file. After the 
# installation is finished, it is recommended to set permissions to read-only 
# using:
#   chmod 750 /etc/gitea
#   chmod 640 /etc/gitea/app.ini
mkdir -p ${GITEA_WORKINGDIR}/{custom,data,log}
chown -R git:git ${GITEA_WORKINGDIR}
chmod -R 750 ${GITEA_WORKINGDIR}
mkdir ${GITEA_CONFIGDIR}
chown root:git ${GITEA_CONFIGDIR}
chmod 770 ${GITEA_CONFIGDIR}


echo $GITEA_BINFILE_NAME
exit 0;
