gitea_nginx_configure () {
  echo "\
upstream gitea_api {
  server unix:${GITEA_WORKINGDIR}/gitea.sock fail_timeout=1;
}


server {
  listen 80;
  server_name ${GITEA_DOMAIN};

  location / {
    proxy_pass http://gitea_api;
    proxy_set_header Host \$host;
    proxy_set_header X-Real-IP \$remote_addr;
    proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto \$scheme;
  }
}
" > /etc/nginx/sites-available/${GITEA_DOMAIN}
  ln -s /etc/nginx/sites-available/${GITEA_DOMAIN} \
    /etc/nginx/sites-enabled/${GITEA_DOMAIN}
}
