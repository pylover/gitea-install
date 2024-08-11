#! /usr/bin/env bash


source ./common.sh
source ./vars.sh
source ./download.sh
source ./config.sh
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
  apt-get install -y wget git
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
if [ -z "$(grep -P "^${GITEA_USER}" /etc/passwd)" ]; then
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
mkdir -p ${GITEA_WORKINGDIR}/{custom,data,log}
chown -R ${GITEA_USER}:${GITEA_USER} ${GITEA_WORKINGDIR}
chmod -R 750 ${GITEA_WORKINGDIR}
mkdir -p ${GITEA_CONFIGDIR}
chown root:${GITEA_USER} ${GITEA_CONFIGDIR}
chmod 750 ${GITEA_CONFIGDIR}


# Copy the Gitea binary to a global location
cp ${GITEA_BINFILE_LOCAL} /usr/local/bin/gitea
chmod +x /usr/local/bin/gitea


# Enabling Gitea bash autocompletion (from 1.19)
read -p "Do you want to enable bash auto-completion for Gitea? [Y/n] " 
if [ -z $REPLY ] || [[ $REPLY =~ ^[Yy]$ ]]; then
  curl ${GITEA_BASHAUTOCOMPLETIONSCRIPT} \
    > /usr/share/bash-completion/completions/gitea
fi


# Prepare the dtabase
read -p "Do you want to create and grant db to ${GITEA_USER} user? [Y/n] " 
if [ -z $REPLY ] || [[ $REPLY =~ ^[Yy]$ ]]; then
  sql CREATE ROLE ${GITEA_USER} WITH LOGIN PASSWORD \'${GITEA_DBPASS}\'
  sql CREATE DATABASE gitea WITH OWNER ${GITEA_USER} TEMPLATE template0 \
    ENCODING UTF8 LC_COLLATE \'en_US.UTF-8\' LC_CTYPE \'en_US.UTF-8\'
fi


# Gitea configuration
read -p "Do you want to create ${GITEA_CONFIGDIR}/app.ini? [Y/n] " 
if [ -z $REPLY ] || [[ $REPLY =~ ^[Yy]$ ]]; then
  gitea_config_create
  chmod 640 ${GITEA_CONFIGDIR}/app.ini
fi


# Systemd
read -p "Do you want to create Systemd service and socket for Gitea? [Y/n] " 
if [ -z $REPLY ] || [[ $REPLY =~ ^[Yy]$ ]]; then
  systemctl stop gitea.{socket,service}
  gitea_systemd_createunit
  systemctl daemon-reload
  systemctl enable gitea.{socket,service}
  systemctl start gitea.{socket,service}
fi


# Nginx
read -p "Do you want to install and configure Nginx [Y/n] " 
if [ -z $REPLY ] || [[ $REPLY =~ ^[Yy]$ ]]; then
  apt install -y nginx
  
  while [ -z ${GITEA_DOMAIN} ]; do
    read -p "Please enter a domain name: "  GITEA_DOMAIN
  done
  
  gitea_nginx_configure

  # SSL
  read -p "Do you want to install and enable certbot [Y/n] " 
  if [ -z $REPLY ] || [[ $REPLY =~ ^[Yy]$ ]]; then
    apt install -y certbot python3-certbot-nginx
    sudo certbot --nginx -d ${GITEA_DOMAIN}
  fi
fi


APP_URL=https://${GITEA_DOMAIN}/
echo "Bingo! Gitea webserver successfully hosted on: ${APP_URL}"
