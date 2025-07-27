#!/bin/bash

shopt -s nullglob
pthtop="$(cd "$(dirname "${0}")/../.." && pwd)"

l=("${pthtop}"/import/*)

for i in "${l[@]}"
do
  if test ! -e "${i}"/manage/cnf/latest.txt
  then
    if test -e "${i}/export"
    then
      echo "export: ${i}"
      cd "${i}/export" && tar -cf - * | (cd "${pthtop}"/export && tar -xf -)
    fi
  fi
done

for i in "${l[@]}"
do
  if test -e "${i}"/manage/cnf/latest.txt
  then
    if test -e "${i}/export"
    then
      echo "export: ${i}"
      cd "${i}/export" && tar -cf - * | (cd "${pthtop}"/export && tar -xf -)
    fi
  fi
done
