#!/bin/bash
set -e

duration=$1

starttime=$(date +%s)
endtime=$(( $starttime + $duration ))
nowtime=$(date +%s)
if [[ -f pre.sh ]]; then
    . pre.sh
fi
terraform init
while [ $nowtime -le $endtime ]; do
    set +e
    terraform apply -auto-approve
    exit_code=$?
    set -e
    if [[ $exit_code -eq 0 ]]; then
        hadsuccess=true
    fi
    # without any successful terraform apply, terraform output would fail
    if [[ ! -z $hadsuccess ]]; then
        date +"%T">>output.txt
        terraform output>>output.txt
    fi
    sleep $(( $RANDOM % 2 ))
    nowtime=$(date +%s)
done
