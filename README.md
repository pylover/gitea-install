# gitea-install
A set of scripts to install Gitea on Ubuntu server.


### Dependencies
```bash
sudo apt install make dpkg-dev postgresql
```

#### Postgres
Edit `postgresql.conf` file and congiure to listen on unix domain socket only:
```bash
listen_addresses = ''
#port = 5432
```

## install
```bash
make clean  # to delete previous downloaded binaries
make install
make post-install
```

to start an interactive installation of gitea.
