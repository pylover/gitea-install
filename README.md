# gitea-install
A set of scripts to install Gitea on Ubuntu server.


### Dependencies
```bash
sudo apt install make dpkg-dev postgresql wget git
```

## install
Create a `vars.user.sh` file (optional), then:

```bash
make install
```

to start an interactive installation of gitea.


## uninstall
```bash
make uninstall
```
