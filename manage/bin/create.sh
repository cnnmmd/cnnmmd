#!/bin/bash

pthtop="$(cd "$(dirname "${0}")/../.." && pwd)"

if test ! -e "${pthtop}"/export
then
  mkdir "${pthtop}"/export
fi

if test ! -e "${pthtop}"/import
then
  mkdir "${pthtop}"/import
  mkdir "${pthtop}"/import_custom
fi

if test ! -e "${pthtop}"/strage
then
  mkdir "${pthtop}"/strage
fi

touch "${pthtop}"/manage/cnf/cnfsrc_custom.txt
touch "${pthtop}"/manage/cnf/depend_custom.txt
touch "${pthtop}"/manage/cnf/except_custom.txt
