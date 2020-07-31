#!/bin/bash

export SCRIPT_LOCT=`dirname $0`
export SCRIPT_LOCT=`cd $SCRIPT_LOCT; pwd`

cd $SCRIPT_LOCT/..

docker rm -f turtl-server turtl-postgres turtl-nginx turtl-inlets >/dev/null 2>&1

echo "* Operation complete."



