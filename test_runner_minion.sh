#!/bin/bash
set -e

duration=$1

starttime=$(date +%s)
endtime=$(( $starttime + $duration ))
nowtime=$(date +%s)

terraform init
while [ $nowtime -le $endtime ]; do
    set +e
    ~/go/bin/terraform apply -auto-approve
    set -e
    date>>output.txt
    ~/go/bin/terraform output>>output.txt
    sleep $((1 + $RANDOM % 10))
    nowtime=$(date +%s)
done
