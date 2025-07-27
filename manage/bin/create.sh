#!/bin/bash

pthtop="$(cd "$(dirname "${0}")/../.." && pwd)"

if test ! -e "${pthtop}"/strage
then
  mkdir "${pthtop}"/strage
fi

if test ! -e "${pthtop}"/export
then
  mkdir "${pthtop}"/export
fi

if test ! -e "${pthtop}"/import
then
  mkdir "${pthtop}"/import
  mkdir "${pthtop}"/import/custom
  mkdir "${pthtop}"/import/custom/export
  mkdir "${pthtop}"/import/custom/manage
  mkdir "${pthtop}"/import/custom/manage/cnf
  touch "${pthtop}"/import/custom/manage/cnf/latest.txt
fi

touch "${pthtop}"/manage/cnf/cnfsrc_custom.txt
touch "${pthtop}"/manage/cnf/except_custom.txt
