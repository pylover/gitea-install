gitea_binfile_verify () {
  echo "Checking Gitea binary file's checksum..."
  if [ ! -f ${GITEA_BINFILE_CHKSUMFILE} ]; then
    gpg -q --keyserver ${GITEA_GPGKEYSERVER} --recv ${GITEA_GPGKEYID}
    wget --directory-prefix ${DLDIR} ${GITEA_DLURL}.asc
  fi
  gpg -q --verify ${GITEA_BINFILE_CHKSUMFILE} ${GITEA_BINFILE_LOCAL} \
    && (echo "Checksum OK: ${GITEA_BINFILE_LOCAL}" && return 0)  \
    || (echo "Invalid Checksum: ${GITEA_BINFILE_LOCAL}" && return 1)
}


function gitea_binfile_download () {
  echo "Downloading Gitea binary..."
  wget --directory-prefix ${DLDIR} ${GITEA_DLURL}
}
