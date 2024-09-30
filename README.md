# gitea-install
A set of scripts to install Gitea on Ubuntu server.


### Dependencies
```bash
sudo apt install make dpkg-dev postgresql wget git
```

## install
Create a `vars.user.sh` file:
```bash
GITEA_DOMAIN=example.com
APP_NAME=Foo
APP_ADMINUSER=admin
APP_ADMINEMAIL=admin@example.com
APP_ADMINPASS=strongpassword

# Optional
SOCKS5_PROXY=localhost:8080
```

Then:
```bash
make install
```


## uninstall
```bash
make uninstall
```
