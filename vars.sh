OS=$(echo ${OSTYPE} | cut -d'-' -f1)
ARCH=$(dpkg-architecture -q DEB_BUILD_ARCH)
GITEA_VERSION=1.22.1
GITEA_DOWNLOADURL=https://dl.gitea.com/gitea/
GITEA_BINFILENAME="gitea-${GITEA_VERSION}-${OS}-${ARCH}"
