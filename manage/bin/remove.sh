#!/bin/bash

pthtop="$(cd "$(dirname "${0}")/../.." && pwd)"

echo "remove: ${pthtop}/export/*" # DBG
rm -rf "${pthtop}"/export/*
