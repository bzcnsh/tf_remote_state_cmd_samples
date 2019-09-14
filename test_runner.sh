#!/bin/bash
set -x -e

# run n concurrent tests, each runs terraform apply in a loop.
# 
backend_type=$1
duration=$2

export DEBUG_LOG_FILE=/tmp/${backend_type}.log

if [ "$#" -ne 2 ]; then
    echo "required arguments are: backend_type test_duration_in_seconds"
    echo "backend_type: path to the backend scripts"
    echo "test_duration_in_seconds: test duration in seconds"
    exit 1
fi

rm -rf workspace
mkdir workspace

cp -R tests/* workspace/
for d in workspace/* ; do
    cp $backend_type/* $d/
    cp test_runner_minion.sh $d/
    pushd $d
    ./test_runner_minion.sh $duration &
    popd
done
