err () {
  2>&1 echo $@
}


sql () {
  echo $@ | sudo -u postgres psql
}


validate () {
  # Check the shell
  if [ "${SHELL}" != "/bin/bash" ]; then
    err "Please run this script with /bin/bash"
    exit 1
  fi
  
  
  # Check the architecture and distribution
  if [ "${OSTYPE}" != "linux-gnu" ] || [ ! -f "/etc/debian_version" ]; then
    err "Invalid OS: ${OSTYPE}, Only debian and it's descendant are supported."
    exit 1
  fi
  
  
  # Check the privileges
  if [ "$(whoami)" != "root" ]; then
    err "Please run this script as root"
    exit 1
  fi
  
  while [ -z ${GITEA_DOMAIN} ]; do
    read -p "Please enter a domain name: " GITEA_DOMAIN
  done
}
