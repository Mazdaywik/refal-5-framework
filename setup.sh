#!/bin/bash

FWDIR=$(dirname $0)
for r in ${FWDIR}/lib ${FWDIR}/lib/posix; do
  refc ${r}
done

echo Framework for Refal-5 is prepared.
echo
echo For using this framework add folders
echo  - ${FWDIR}/lib/posix
echo  - ${FWDIR}/lib
echo to REF5RSL environment variable.
