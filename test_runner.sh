#!/bin/bash
set -x -e

backend_type=$1
duration=$2

rm -rf workspace
mkdir workspace

cp -R tests/* workspace/
for d in workspace/* ; do
    cp $backend_type/* $d/
    cp test_runner_minion.sh $d/
    pushd $d
    test_runner_minion.sh $duration &
    popd
done
