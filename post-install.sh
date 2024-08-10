#! /usr/bin/env bash


source ./common.sh
source ./vars.sh
source ./systemd.sh
source ./nginx.sh


# Fixing configuration directory and file permissions
chmod 750 ${GITEA_CONFIGDIR}
chmod 640 ${GITEA_CONFIGDIR}/app.ini


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


# Systemd
read -p "Do you want to create Systemd service and socket for Gitea? [Y/n] " 
if [ -z $REPLY ] || [[ $REPLY =~ ^[Yy]$ ]]; then
  systemctl stop gitea.{socket,service}
  gitea_systemd_createunit
  systemctl daemon-reload
  systemctl enable gitea.{socket,service}
  systemctl start gitea.{socket,service}
fi


while [ -z ${GITEA_DOMAIN} ]; do
  read -p "Please enter a domain name: "  GITEA_DOMAIN
done


# Nginx
read -p "Do you want to install and configure Nginx [Y/n] " 
if [ -z $REPLY ] || [[ $REPLY =~ ^[Yy]$ ]]; then
  apt install -y nginx
  gitea_nginx_configure
fi


exit 0;
