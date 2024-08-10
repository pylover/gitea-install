err () {
  2>&1 echo $@
}


sql () {
  echo $@ | sudo -u postgres psql
}
