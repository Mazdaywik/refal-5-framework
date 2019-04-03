#!/bin/bash

for r in *.ref posix/*.ref; do
  refc ${r} || exit 1
done
