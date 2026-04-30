#! /usr/bin/env bash


source ./common.sh
source ./vars.sh
source ./download.sh
source ./config.sh
source ./systemd.sh
source ./nginx.sh


# Validate the environment
validate


# stop services
systemctl stop ${GITEA_SYSTEMD_SERVICEFILE}
systemctl disable ${GITEA_SYSTEMD_SERVICEFILE}


# TODO: Backup /home/${GITEA_USER}
# TODO: Backup ${GITEA_DBNAME} database
# TODO: Backup ${GITEA_WORKINGDIR}
# TODO: Backup ${GITEA_CONFIGDIR}


# delete database and role
sql DROP DATABASE ${GITEA_DBNAME} 
sql DROP ROLE ${GITEA_USER} 


# Delete directory structure
rm -rf ${GITEA_WORKINGDIR}/{custom,data,log}
rmdir ${GITEA_WORKINGDIR}
rm -rf ${GITEA_CONFIGDIR}


# delete binary
rm -r ${GITEA_BIN}


# delete autocompletion
rm -r /home/${GITEA_USER}/.local/share/bash-completion/completions/gitea


# delete systemd service and socket
rm ${GITEA_SYSTEMD_SERVICEFILE}
systemctl daemon-reload


# delete nginx config
service nginx stop
rm /etc/nginx/sites-available/${GITEA_DOMAIN}
rm /etc/nginx/sites-enabled/${GITEA_DOMAIN}
service nginx start


# delete certbot
certbot delete --cert-name ${GITEA_DOMAIN}


# Delete the user
if [ -n "$(grep -P "^${GITEA_USER}" /etc/passwd)" ]; then
  deluser \
     --system \
     --remove-home \
     ${GITEA_USER}
fi


echo "Bingo! Gitea webserver successfully uninstalled."
