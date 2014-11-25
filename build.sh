#!/bin/bash

set -e

if [ "$#" -eq 0 ]; then cmd=help; else cmd=$1; fi

purs_files () {
  find src bower_components \
    -name "*.purs" \
    ! -name "externs.purs" \
    ! -path '*/examples/*' \
    ! -path '*/tests/*'
}

case "$cmd" in
  psc)
    purs_files | xargs psc -m Main --main Main --output dist/main.js
  ;;
  dot-psci)
    purs_files | sed 's/^/:m /' > .psci
  ;;
  psc-make)
    purs_files | xargs psc-make
  ;;
  help)
    cat >&2 <<USAGE
Usage: ./build <task> [arguments]

Available tasks:

    psc              Compile project to a bundle
    psc-make         Compile .purs modules to CommonJS modules
    dot-psci         Generate .psci file with all project's modules
    help             Show usage
USAGE
esac
