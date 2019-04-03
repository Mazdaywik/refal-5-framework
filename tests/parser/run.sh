#!/bin/bash

run_test_aux() {
  echo Passing $1...
  if
    echo Y | refgo test-parser+Refal5-Parser+Refal5-Lexer+Utils $1 2>__err.txt
  then
    echo Parser failed, see __err.txt for details
    exit 1
  fi
  echo

  rm -f __err.txt
}

run_test_aux.BAD-SYNTAX() 

source ../c-plus-plus.conf.sh

if [ -z "$1" ]; then
  for s in *.ref; do
    run_test $s
  done
else
  for s in $*; do
    run_test $s
  done
fi
