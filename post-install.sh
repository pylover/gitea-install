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


# Systemd
read -p "Do you want to create Systemd service and socket for Gitea? [Y/n] " 
if [ -z $REPLY ] || [[ $REPLY =~ ^[Yy]$ ]]; then
  systemctl is-active gitea.service \
    && systemctl stop gitea.service
  systemctl is-active gitea.socket \
    && systemctl stop gitea.scoket
  gitea_systemd_createunit
  sudo systemctl enable gitea
  sudo systemctl start gitea
fi


# Nginx
read -p "Do you want to install and configure Nginx [Y/n] " 
if [ -z $REPLY ] || [[ $REPLY =~ ^[Yy]$ ]]; then
  apt install nginx
  gite_nginx_configure
fi


exit 0;
