#! /usr/bin/env bash


source ./common.sh
source ./vars.sh
source ./download.sh
source ./config.sh
source ./systemd.sh
source ./nginx.sh
source ./postgresql.sh


# Validate the environment
validate


# Set proxy if any
if [ -n "${SOCKS5_PROXY}" ]; then
  export socks_proxy="socks5://${SOCKS5_PROXY}"
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
cp ${GITEA_BINFILE_LOCAL} ${GITEA_BIN}
chmod +x ${GITEA_BIN}


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
read -p "Do you want to create ${GITEA_CONFIGFILE}? [Y/n] " 
if [ -z $REPLY ] || [[ $REPLY =~ ^[Yy]$ ]]; then
  gitea_config_create
  chown root:${GITEA_USER} ${GITEA_CONFIGFILE}
  chmod 640 ${GITEA_CONFIGFILE}
fi


# Gitea admin user
if [ -n "${APP_ADMINUSER}" ] && [ -n "${APP_ADMINPASS}" ] \
    && [ -n "${APP_ADMINEMAIL}" ]; then
  sudo -u ${GITEA_USER} ${GITEA_BIN} -c ${GITEA_CONFIGFILE} \
    admin user create \
    --admin \
    --username ${APP_ADMINUSER} \
    --email ${APP_ADMINEMAIL} \
    --password ${APP_ADMINPASS}
fi


# Systemd
read -p "Do you want to create Systemd service for Gitea? [Y/n] " 
if [ -z $REPLY ] || [[ $REPLY =~ ^[Yy]$ ]]; then
  systemctl stop gitea.service
  gitea_systemd_createunit
  systemctl daemon-reload
  systemctl enable gitea.service
  systemctl start gitea.service
fi


# Nginx
read -p "Do you want to install and configure Nginx [Y/n] " 
if [ -z $REPLY ] || [[ $REPLY =~ ^[Yy]$ ]]; then
  apt install -y nginx
  
  gitea_nginx_configure
  service nginx restart

  # SSL
  read -p "Do you want to install and enable certbot [N/y] " 
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    apt install -y certbot python3-certbot-nginx
    sudo certbot --nginx -d ${GITEA_DOMAIN}
  fi
fi


APP_URL=https://${GITEA_DOMAIN}/
echo "Bingo! Gitea webserver successfully hosted on: ${APP_URL}"
