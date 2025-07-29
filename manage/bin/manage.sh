#!/bin/bash

#---------------------------------------------------------------------------
# 設定

pthmgr="$(cd "$(dirname "${0}")/.." && pwd)"
pthtop="$(cd "$(dirname "${0}")/../.." && pwd)"
source "${pthmgr}"/lib/shared.sh

pthsrc="${pthmgr}/cnf/cnfsrc.txt" # プラグイン群のソース
pthsrd="${pthmgr}/cnf/cnfsrc_custom.txt"
pthdpd="${pthmgr}/cnf/depend.txt" # 依存するプラグイン群
pthdpe="${pthmgr}/cnf/depend_custom.txt"
pthexc="${pthmgr}/cnf/except.txt" # 除外するプラグイン群
pthexd="${pthmgr}/cnf/except_custom.txt"

action="${1}" # アクション
namsrc="${2}" # プラグイン

#---------------------------------------------------------------------------
# 関数：プラグインのソース群の設定を取得（ブランチ／リモートリポジトリ）

function getrem {
  local namsrc=${1}
  local brcsrc remsrc

  brcsrc=$(cat "${pthsrc}" "${pthsrd}" | sed '/^#/d' | awk '{m[$1]=$0} END {for (k in m) {print m[k]}}' | awk -v p=${namsrc} '$1 == p {print $2}')
  remsrc=$(cat "${pthsrc}" "${pthsrd}" | sed '/^#/d' | awk '{m[$1]=$0} END {for (k in m) {print m[k]}}' | awk -v p=${namsrc} '$1 == p {print $3}')
  echo "${brcsrc} ${remsrc}"
}

#---------------------------------------------------------------------------
# 関数：プラグインを更新（ブランチ／リモートリポジトリの変更を反映）

function getdif {
  local namsrc=${1}
  local brcsrc remsrc brccrr remcrr
  local stsupd=0

  read brcsrc remsrc < <(getrem ${namsrc})
  echo "status: branch: ${brcsrc}" # DBG
  echo "status: remote: ${remsrc}" # DBG
  brccrr=$(git rev-parse --abbrev-ref HEAD)
  remcrr=$(git remote get-url origin)
  if test ${brccrr} != ${brcsrc}
  then
    git switch ${brcsrc} || git switch -c ${brcsrc}
    stsupd=1
  fi
  if test ${remsrc} != ${remsrc}
  then
    git remote set-url origin ${remsrc}
    stsupd=1
  fi
  git fetch origin ${brcsrc}
  if ! git diff --quiet HEAD "origin/${brcsrc}"
  then
    git reset --hard "origin/${brcsrc}"
    stsupd=1
  fi
  return ${stsupd}
}

#---------------------------------------------------------------------------
# 関数：プラグインを追加／更新

function getsrc {
  local namsrc=${1}
  local brcsrc remsrc
  local stsupd=0

  if test -d "${pthtop}"/import/${namsrc}
  then
    if cnfrtn "update: ${namsrc}"
    then
      cd "${pthtop}"/import/${namsrc}
      getdif ${namsrc}
      stsupd=${?}
    fi
  else
    if cnfrtn "import: ${namsrc}"
    then
      read brcsrc remsrc < <(getrem ${namsrc})
      cd "${pthtop}"/import
      git clone -b ${brcsrc} ${remsrc}
      stsupd=1
    fi
  fi
  return ${stsupd}
}

#---------------------------------------------------------------------------
# 関数：依存関係にあるプラグイン群を取得（重複あり）

function getdpd {
  local namsrc=${1}
  local l i

  if test ${depend} -eq 1
  then
    l=($(
      cat "${pthdpe}" "${pthdpd}" |
      awk -v k="$namsrc" '
        $0 == k    {i=1; next}
        i && /^- / {sub(/^- /, ""); print; next}
        i && !/^-/ {exit}
      '
    ))
    for i in ${l[@]}
    do
      if cat "${pthdpe}" "${pthdpd}" | grep -qx -- "$namsrc"
      then
        if flgexc ${i}
        then
          test ${action} = 'create' -o ${action} = 'launch' && lstdpd=(${i} ${lstdpd[@]})
          test ${action} = 'delete' -o ${action} = 'finish' && lstdpd=(${lstdpd[@]} ${i})
        fi
        getdpd ${i}
      fi
    done
  fi
}

#---------------------------------------------------------------------------
# 関数：対象のプラグインが、取得対象が外されているかどうか

function flgexc {
  local strsrc="${1}"

  if ! grep -Fxq "${strsrc}" "${pthexc}" && ! grep -Fxq "${strsrc}" "${pthexd}"
  then
    return 0
  else
    return 1
  fi
}

#---------------------------------------------------------------------------
# 処理

if test "${3}" = '-d' -o "${3}" = '--depend'
then
  depend=1
else
  depend=0
fi

"${pthtop}"/manage/bin/create.sh

if flgexc ${namsrc}
then
  lstdpd=(${namsrc})
fi
getdpd ${namsrc}
unqdpd=$(echo ${lstdpd[@]} | tr ' ' '\n' | awk '!s[$0]++')

#---------------------------------------------------------------------------
# 処理：追加：インポート

if test ${action} = 'create'
then
  if test ${namsrc} = 'manage'
  then
    if cnfrtn 'update: manage'
    then
      cd "${pthtop}"
      getdif ${namsrc}
    fi
  else
    if cnfrtn "target: create (import) : ${unqdpd[@]}"
    then
      stsupd=0
      for i in ${unqdpd[@]}
      do
        getsrc ${i}
        stsupd=${?}
      done
      if test ${stsupd} -ne 0
      then
        echo "status: update (remove & append) : export"
        "${pthtop}"/manage/bin/remove.sh
        "${pthtop}"/manage/bin/append.sh
      fi
    fi
  fi
fi

#---------------------------------------------------------------------------
# 処理：固有：プラグイン

if test ${action} = 'create' -o ${action} = 'launch' -o ${action} = 'delete' -o ${action} = 'finish'
then
  if cnfrtn "target: ${action} (plugin) : ${unqdpd[@]}"
  then
    # 公式フォルダ
    for i in ${unqdpd[@]}
    do
      f="${pthtop}"/import/${i}/manage/bin/${action}.sh
      if test -e "${f}"
      then
        if cnfrtn "${action}: ${i}"
        then
          "${f}"
        fi
      fi
    done
    # 固有フォルダ
    for i in ${unqdpd[@]}
    do
      f="${pthtop}"/import_custom/${i}/manage/bin/${action}.sh
      if test -e "${f}"
      then
        if cnfrtn "${action}: ${i}"
        then
          "${f}"
        fi
      fi
    done
    #
  fi
fi

#---------------------------------------------------------------------------
# 処理：削除：インポート

if test ${action} = 'delete'
then
  if cnfrtn "target: delete (import) : ${unqdpd[@]}"
  then
    for i in ${unqdpd[@]}
    do
      if test -d "${pthtop}"/import/${i}
      then
        if cnfrtn "delete: ${i}: ${pthtop}/import/${i}"
        then
          /bin/rm -rf "${pthtop}"/import/${i}
        fi
      fi
    done
    echo "status: update (remove & append) : export"
    "${pthtop}"/manage/bin/remove.sh
    "${pthtop}"/manage/bin/append.sh
  fi

  if test ${namsrc} = 'manage'
  then
    "${pthtop}"/manage/bin/delete.sh
  fi
fi
