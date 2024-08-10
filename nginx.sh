gitea_nginx_configure () {
  echo "\
upstream gitea_api {
  server unix:/run/gitea/gitea.sock fail_timeout=1;
}


server {
  listen 80;
  server_name ${GITEA_DOMAIN};

  location / {
    proxy_set_header X-Forwarded-Host \$host;
    proxy_set_header X-Forwarded-Server \$host;
    proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
    proxy_pass http://gitea_api;
  }
}
" > /etc/nginx/sites-available/${GITEA_DOMAIN}
  ln -s /etc/nginx/sites-available/${GITEA_DOMAIN} \
    /etc/nginx/sites-enabled/${GITEA_DOMAIN}
  service nginx restart
}
