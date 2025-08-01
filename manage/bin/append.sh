#!/bin/bash

shopt -s nullglob
pthtop="$(cd "$(dirname "${0}")/../.." && pwd)"

l=("${pthtop}"/import/*)
for i in "${l[@]}"
do
  if test -e "${i}/export"
  then
    echo "export: ${i}"
    cd "${i}/export"
    l=(*)
    if test ${#l[@]} -gt 0
    then
      tar -cf - * | (cd "${pthtop}"/export && tar -xf -)
    fi
  fi
done

l=("${pthtop}"/import_custom/*)
for i in "${l[@]}"
do
  if test -e "${i}/export"
  then
    echo "export: ${i}"
    cd "${i}/export"
    l=(*)
    if test ${#l[@]} -gt 0
    then
      tar -cf - * | (cd "${pthtop}"/export && tar -xf -)
    fi
  fi
done
