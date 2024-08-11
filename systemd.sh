gitea_systemd_createunit () {
  echo "\
[Unit]
Description=Gitea (Git with a cup of tea)
After=network.target
Wants=postgresql.service
After=postgresql.service

[Service]
# LimitNOFILE=4096:4096
RestartSec=2s
Type=simple
User=${GITEA_USER}
Group=${GITEA_USER}
WorkingDirectory=${GITEA_WORKINGDIR}
RuntimeDirectory=gitea
ExecStart=/usr/local/bin/gitea web --config ${GITEA_CONFIGDIR}/app.ini
Restart=always
Environment=USER=${GITEA_USER} 
Environment=HOME=/home/${GITEA_USER} 
Environment=GITEA_WORK_DIR=${GITEA_WORKINGDIR}

[Install]
WantedBy=multi-user.target
" > ${GITEA_SYSTEMD_SERVICEFILE}
}
