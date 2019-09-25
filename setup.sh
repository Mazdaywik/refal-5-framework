#!/bin/bash

FWDIR=$(cd $(dirname $0) && pwd)
( cd $FWDIR/lib && ./refcall.sh )

echo Framework for Refal-5 is prepared.
echo
echo For using this framework add folders
echo  - ${FWDIR}/lib/posix
echo  - ${FWDIR}/lib
echo to REF5RSL environment variable.
