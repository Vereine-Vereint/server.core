
function check_env() {
  # $1 is hostname, $2 is boolean if we should ignore FTP_.* variables

  # assert $1 is hostname
  if [ -z "$1" ]; then
    echo "Usage: ./create.sh <Hostname>"
    exit 1
  fi

  # assert $1.env exists
  if [ ! -f $PATH_ROOT/$1.env ]; then
    echo "[WARN] File $PATH_ROOT/$1.env does not exist"
    echo "       Copying a template..."
    cp $PATH_CORE/template.env $PATH_ROOT/$1.env
    echo ""
    echo "Please fill in the required environment variables in $PATH_ROOT/$1.env"
    exit 2
  fi

  # load $PATH_ROOT/$1.env
  source $PATH_ROOT/$1.env

  # assert $1 == $HOSTNAME
  if [ "$1" != "$HOSTNAME" ]; then
    echo "Hostname mismatch: $1 != $HOSTNAME"
    exit 1
  fi

  # assert required environment variables
  all_vars=$(grep -oP '^[A-Z_]+(?==)' $PATH_CORE/template.env | sort | uniq)
  echo "Checking for required environment variables..."
  all_set=true
  for var in $all_vars; do
    var=$(echo $var | sed 's/[\$\{\}]//g')
    if [ -z "${!var}" ]; then
      if [ "$2" = true ] && [[ $var == FTP_* ]]; then
        echo "[WARN] Environment variable $var is not set"
        continue
      fi
      echo "[ERR] Environment variable $var is not set"
      all_set=false
    fi
  done
  if [ "$all_set" = false ]; then
    echo "Please fill in the required environment variables in $PATH_ROOT/$1.env"
    exit 2
  fi

  echo "[OK] All required environment variables are set"
}
