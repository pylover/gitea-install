# gitea-install
A set of scripts to install Gitea on Ubuntu server.


### Dependencies
```bash
sudo apt install make dpkg-dev
```

## install
```bash
make clean  # to delete previous downloaded binaries
make install
make post-install
```

to start an interactive installation of gitea.
