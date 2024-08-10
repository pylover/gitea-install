function gitea_ensurechecksum () {
  echo "Checking Gitea binary file's checksum..."
  if [ ! -f ${GITEA_BINARY_CHECKSUMFILE} ]; then
    gpg -q --keyserver ${GITEA_GPGKEYSERVER} --recv ${GITEA_GPGKEYID}
    wget --directory-prefix ${DLDIR} ${GITEA_DOWNLOADURL}.asc
  fi
  gpg -q --verify ${GITEA_BINARY_CHECKSUMFILE} ${GITEA_BINARY} \
    && (echo "Checksum OK: ${GITEA_BINARY}" && return 0)  \
    || (echo "Invalid Checksum: ${GITEA_BINARY}" && return 1)
}


function gitea_download () {
  if [ -f ${GITEA_BINARY} ]; then
    gitea_ensurechecksum || rm ${GITEA_BINARY}*
  fi

  if [ ! -f ${GITEA_BINARY} ]; then
    mkdir -p ${DLDIR}
    echo "Downloading Gitea binary..."
    wget --directory-prefix ${DLDIR} ${GITEA_DOWNLOADURL}
    gitea_ensurechecksum || exit 1
  fi
}
