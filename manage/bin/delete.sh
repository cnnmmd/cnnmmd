#!/bin/bash

pthtop="$(cd "$(dirname "${0}")/../.." && pwd)"
pthmgr="$(cd "$(dirname "${0}")/.." && pwd)"
source "${pthmgr}"/lib/shared.sh

if cnfrtn 'delete: export|import'
then
  /bin/rm -rf "${pthtop}"/export
  /bin/rm -rf "${pthtop}"/import
fi
