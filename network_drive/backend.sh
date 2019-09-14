#!/bin/bash
# stores terraform state in network drive
# locks state by adding a lock file to the same network drive before updating state
# unlocks state by removing the lock file from the network drive after updating state

set -e

# files to pass states and lock between terraform and command
# should match configuration in the backend.tf file
state_transfer="state_transfer"
lock_transfer="lock_transfer"

# change below to reflect your environment
# please pre-configure the network drive, and folder structure, and test access
storage_dir=/mnt/remote_fs/tf_states/resilience_app

# will be one of GET, PUT, DELETE, LOCK, UNLOCK
command=$1

case $command in
  PUT)
    yes | cp $state_transfer $storage_dir/
    exit 0
    ;;
  GET)
    if [[ -f $storage_dir/$state_transfer ]]; then
      yes | cp $storage_dir/$state_transfer ./
    fi
    exit 0
    ;;
  LOCK)
    if [[ -f $storage_dir/$lock_transfer ]]; then
        echo "FAIL. cannot obtain lock"
        cat $storage_dir/$lock_transfer
        exit 1
    else
        cp -n $lock_transfer $storage_dir
        cat $storage_dir/$lock_transfer
        exit 0
    fi
    ;;
  UNLOCK)
    if [[ -f $storage_dir/$lock_transfer ]]; then
        rm -f $storage_dir/$lock_transfer
    else
        echo "FAIL. lock file does not exists"
        exit 1
    fi
    exit 0
    ;;
  DELETE)
    if [[ -f $storage_dir/$state_transfer ]]; then
        rm -f $storage_dir/$state_transfer
    else
        echo "FAIL. states file does not exists"
        exit 1
    fi
    exit 0
    ;;
  *)
    echo "FAIL. unknow command: $command"
    exit 1
    ;;
esac

    

