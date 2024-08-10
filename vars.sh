# Common variables
OS=`echo ${OSTYPE} | cut -d'-' -f1`
ARCH=`dpkg-architecture -q DEB_BUILD_ARCH`
HERE=`dirname "$(readlink -f "$BASH_SOURCE")"`
DLDIR=${HERE}/dl


# Gitea
GITEA_VERSION=1.22.1
GITEA_DLBASEURL=https://dl.gitea.com/gitea
GITEA_BINFILE_NAME="gitea-${GITEA_VERSION}-${OS}-${ARCH}"
GITEA_BINFILE_LOCAL=${DLDIR}/${GITEA_BINFILE_NAME}
GITEA_DLURL="${GITEA_DLBASEURL}/${GITEA_VERSION}/${GITEA_BINFILE_NAME}"
GITEA_BINFILE_CHKSUMFILE=${DLDIR}/${GITEA_BINFILE_NAME}.asc
GITEA_GPGKEYID=7C9E68152594688862D62AF62D9AE806EC1592E2
GITEA_GPGKEYSERVER=keys.openpgp.org
GITEA_WORKINGDIR=/var/lib/gitea
GITEA_CONFIGDIR=/etc/gitea
GITEA_BASHAUTOCOMPLETIONSCRIPT=https://raw.githubusercontent.com/go-gitea/gitea/main/contrib/autocompletion/bash_autocomplete
GITEA_USER=git


# Systemd
GITEA_SYSTEMD_SOCKETFILE=/etc/systemd/system/gitea.service
GITEA_SYSTEMD_SERVICEFILE=/etc/systemd/system/gitea.service

# Nginx
GITEA_DOMAIN=
