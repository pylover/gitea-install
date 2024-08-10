# gitea-install
A set of scripts to install Gitea on Ubuntu server.


### Dependencies
```bash
sudo apt install make dpkg-dev postgresql
```

#### Postgres
Edit `postgresql.conf` file and set 
```bash
listen_addresses = ''
#port = 5432
```

Then, add this to your `pg_hba.conf`
```bash
host    gitea    gitea    127.0.0.1/32    scram-sha-256
```

## install
```bash
make clean  # to delete previous downloaded binaries
make install
make post-install
```

to start an interactive installation of gitea.
