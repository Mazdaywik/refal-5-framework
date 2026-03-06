#!/bin/bash

for r in *.ref; do
  refc ${r} || exit 1
done
