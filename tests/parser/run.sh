#!/bin/bash

run_test() {
  echo Passing $1...
  if
    echo Y | REF5RSL=../../lib refgo test-parser+R5FW-Parser+LibraryEx $1 2>__err.txt
  then
    echo Parser failed, see __err.txt for details
    exit 1
  fi
  echo

  rm -f __err.txt
}

if [[ -z "$1" ]]; then
  for s in *.ref; do
    run_test ${s}
  done
else
  for s in $*; do
    run_test ${s}
  done
fi
