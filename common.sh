OS=$(echo ${OSTYPE} | cut -d'-' -f1)
ARCH=$(dpkg-architecture -q DEB_BUILD_ARCH)
HERE=`dirname "$(readlink -f "$BASH_SOURCE")"`
DLDIR=${HERE}/dl


function err () {
  2>&1 echo $@
}
