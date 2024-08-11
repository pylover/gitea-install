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
systemctl stop gitea.{socket,service}
systemctl disable gitea.{socket,service}


# TODO: Backup /home/git
# TODO: Backup database
# TODO: Backup /var/lib/gitea
# TODO: Backup /etc/gitea


# delete database and role
sql DROP DATABASE gitea 
sql DROP ROLE ${GITEA_USER} 


# Delete directory structure
rm -rf ${GITEA_WORKINGDIR}/{custom,data,log}
rm -rf ${GITEA_CONFIGDIR}


# delete gitea binary
rm /usr/local/bin/gitea


# delete gitea binary autocompletion
rm /usr/share/bash-completion/completions/gitea


# delete systemd service and socket
rm ${GITEA_SYSTEMD_SOCKETFILE}
rm ${GITEA_SYSTEMD_SERVICEFILE}
systemctl daemon-reload


# delete nginx config
service nginx stop
rm /etc/nginx/sites-available/${GITEA_DOMAIN}
rm /etc/nginx/sites-enabled/${GITEA_DOMAIN}
service nginx start


# delete certbot
certbot delete --cert-name ayot.net


# Delete the gitea user
if [ -n "$(grep -P "^${GITEA_USER}" /etc/passwd)" ]; then
  deluser \
     --system \
     --remove-home \
     ${GITEA_USER}
fi


echo "Bingo! Gitea webserver successfully uninstalled."
