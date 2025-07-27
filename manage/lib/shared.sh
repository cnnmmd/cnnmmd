#---------------------------------------------------------------------------

function cnfrtn {
  local msgalr="${1}"
  local r

  /bin/echo -n "${msgalr} (y|n) : "
  read r
  if test ${r} = 'y'
  then
    return 0
  else
    return 1
  fi
}

#---------------------------------------------------------------------------

function addnet {
  local nettgt=${1}

  docker network inspect ${nettgt} > /dev/null 2>&1 || docker network create ${nettgt}
}

#---------------------------------------------------------------------------

function addimg {
  local imgtgt=${1}
  local cnfimg=${2}
  local pthdoc="${3}"

  test -d "${pthdoc}" || mkdir "${pthdoc}"
  docker inspect ${imgtgt} > /dev/null 2>&1 || docker build --no-cache -t ${imgtgt} -f "${cnfimg}" "${pthdoc}"
}

#---------------------------------------------------------------------------

function delnet {
  local nettgt=${1}

  if docker network inspect ${nettgt} > /dev/null 2>&1
  then
    if cnfrtn "delete: ${nettgt}"
    then
      docker network rm ${nettgt}
    fi
  fi
}

#---------------------------------------------------------------------------

function delimg {
  local imgtgt=${1}

  if docker inspect ${imgtgt} > /dev/null 2>&1
  then
    if cnfrtn "delete: ${imgtgt}"
    then
      docker rmi ${imgtgt}
    fi
  fi
}

#---------------------------------------------------------------------------

function runimg {
  local cnfcmp=${1}

  cnfusr="${cnfcmp%.*}_custom.${cnfcmp#*.}"

  if test -f "${cnfusr}"
  then
    docker compose -f "${cnfcmp}" -f "${cnfusr}" up -d
  else
    docker compose -f "${cnfcmp}" up -d
  fi
}

#---------------------------------------------------------------------------

function endimg {
  local cnfcmp=${1}

  cnfusr="${cnfcmp%.*}_custom.${cnfcmp#*.}"

  if test -f "${cnfusr}"
  then
    docker compose -f "${cnfcmp}" -f "${cnfusr}" down
  else
    docker compose -f "${cnfcmp}" down
  fi
}

#---------------------------------------------------------------------------

function runimg_opt {
  local cnfcmp=${1}
  local cnfopt=${2}

  cnfusr="${cnfcmp%.*}_custom.${cnfcmp#*.}"

  if test -f "${cnfusr}"
  then
    docker compose -f "${cnfcmp}" -f "${cnfopt}" -f "${cnfusr}" up -d
  else
    docker compose -f "${cnfcmp}" -f "${cnfopt}" up -d
  fi
}

#---------------------------------------------------------------------------

function endimg_opt {
  local cnfcmp=${1}
  local cnfopt=${2}

  cnfusr="${cnfcmp%.*}_custom.${cnfcmp#*.}"

  if test -f "${cnfusr}"
  then
    docker compose -f "${cnfcmp}" -f "${cnfopt}" -f "${cnfusr}" down
  else
    docker compose -f "${cnfcmp}" -f "${cnfopt}" down
  fi
}
