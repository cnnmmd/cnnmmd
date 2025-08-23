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

  pthtop="$(cd "$(dirname "${0}")/../../../.." && pwd)"
  pthmgr="${pthtop}/manage"
  pthevn="${pthmgr}/cnf/cnfenv.txt"
  pthevm="${pthmgr}/cnf/cnfenv_custom.txt"

  if ! docker inspect ${imgtgt} > /dev/null 2>&1
  then
    adrimg=$(cat "${pthevn}" "${pthevm}" | sed -e '/^#/d' -e 's/\r$//' | awk '{m[$1]=$0} END {for (k in m) {print m[k]}}' | awk -v p=${imgtgt} '$1 == p {print $2}')
    if docker pull ${adrimg}
    then
      docker tag ${adrimg} ${imgtgt}
      docker rmi ${adrimg}
    else
      if test ${adrimg} = '+'
      then
        docker build --no-cache -t ${imgtgt} -f "${cnfimg}" "${pthdoc}"
      fi
    fi
  fi
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

  namprj=$(basename "${cnfcmp}" | sed -E 's/^docker_(.+)\.yml$/\1/')
  cnfusr="${cnfcmp%.*}_custom.${cnfcmp#*.}"

  if test -f "${cnfusr}"
  then
    docker compose -p ${namprj} -f "${cnfcmp}" -f "${cnfusr}" up -d
  else
    docker compose -p ${namprj} -f "${cnfcmp}" up -d
  fi
}

#---------------------------------------------------------------------------

function endimg {
  local cnfcmp=${1}

  namprj=$(basename "${cnfcmp}" | sed -E 's/^docker_(.+)\.yml$/\1/')
  cnfusr="${cnfcmp%.*}_custom.${cnfcmp#*.}"

  if test -f "${cnfusr}"
  then
    docker compose -p ${namprj} -f "${cnfcmp}" -f "${cnfusr}" down
  else
    docker compose -p ${namprj} -f "${cnfcmp}" down
  fi
}

#---------------------------------------------------------------------------

function runimg_opt {
  local cnfcmp=${1}
  local cnfopt=${2}

  namprj=$(basename "${cnfcmp}" | sed -E 's/^docker_(.+)\.yml$/\1/')
  cnfusr="${cnfcmp%.*}_custom.${cnfcmp#*.}"

  if test -f "${cnfusr}"
  then
    docker compose -p ${namprj} -f "${cnfcmp}" -f "${cnfopt}" -f "${cnfusr}" up -d
  else
    docker compose -p ${namprj} -f "${cnfcmp}" -f "${cnfopt}" up -d
  fi
}

#---------------------------------------------------------------------------

function endimg_opt {
  local cnfcmp=${1}
  local cnfopt=${2}

  namprj=$(basename "${cnfcmp}" | sed -E 's/^docker_(.+)\.yml$/\1/')
  cnfusr="${cnfcmp%.*}_custom.${cnfcmp#*.}"

  if test -f "${cnfusr}"
  then
    docker compose -p ${namprj} -f "${cnfcmp}" -f "${cnfopt}" -f "${cnfusr}" down
  else
    docker compose -p ${namprj} -f "${cnfcmp}" -f "${cnfopt}" down
  fi
}
