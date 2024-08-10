ERR="2>&1 echo"


function err () {
  2>&1 echo $@
}
