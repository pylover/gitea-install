#! /usr/bin/env bash


source ./common.sh
source ./vars.sh
source ./download.sh
source ./systemd.sh
source ./nginx.sh


# Check the shell
if [ "${SHELL}" != "/bin/bash" ]; then
  err "Please run this script with /bin/bash"
  exit 1
fi


# Check the architecture and distribution
if [ "${OSTYPE}" != "linux-gnu" ] || [ ! -f "/etc/debian_version" ]; then
  err "Invalid OS: ${OSTYPE}, Only debian and it's descendant are supported."
  exit 1
fi


# Check the privileges
if [ "$(whoami)" != "root" ]; then
  err "Please run this script as root"
  exit 1
fi


# Dependencies
read -p "Do you want to install required debian packages? [Y/n] " 
if [ -z $REPLY ] || [[ $REPLY =~ ^[Yy]$ ]]; then
  apt-get install -y wget git postgresql redis-server
fi


# Downloading the specific binary if required
if [ -f ${GITEA_BINFILE_LOCAL} ]; then
  gitea_binfile_verify || rm ${GITEA_BINFILE_LOCAL}*
fi
if [ ! -f ${GITEA_BINFILE_LOCAL} ]; then
  mkdir -p ${DLDIR}
  gitea_binfile_download
  gitea_binfile_verify || exit 1
fi


# Create the gitea user
if [ -z $(grep -P "^${GITEA_USER}" /etc/passwd) ]; then
  adduser \
     --system \
     --shell /bin/bash \
     --gecos 'Git Version Control' \
     --group \
     --disabled-password \
     --home /home/${GITEA_USER} \
     ${GITEA_USER}
fi


# Create required directory structure
# TODO: /etc/gitea is temporarily set with write permissions for user 
# ${GITEA_USER} so that the web installer can write the configuration file. 
# After the installation is finished, it is recommended to set permissions to 
# read-only using:
#   chmod 750 /etc/gitea
#   chmod 640 /etc/gitea/app.ini
mkdir -p ${GITEA_WORKINGDIR}/{custom,data,log}
chown -R ${GITEA_USER}:${GITEA_USER} ${GITEA_WORKINGDIR}
chmod -R 750 ${GITEA_WORKINGDIR}
mkdir -p ${GITEA_CONFIGDIR}
chown root:${GITEA_USER} ${GITEA_CONFIGDIR}
chmod 770 ${GITEA_CONFIGDIR}


# Copy the Gitea binary to a global location
cp ${GITEA_BINFILE_LOCAL} /usr/local/bin/gitea
chmod +x /usr/local/bin/gitea


# Enabling Gitea bash autocompletion (from 1.19)
read -p "Do you want to enable bash auto-completion for Gitea? [Y/n] " 
if [ -z $REPLY ] || [[ $REPLY =~ ^[Yy]$ ]]; then
  curl ${GITEA_BASHAUTOCOMPLETIONSCRIPT} \
    > /usr/share/bash-completion/completions/gitea
fi


echo "Starting Gitea temporary to configure, press CTRL+C after the \
configuration process finished"
/usr/local/bin/gitea web --config ${GITEA_CONFIGDIR}/app.ini

echo "Run ./post-install.sh"


exit 0;
