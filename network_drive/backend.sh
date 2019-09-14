#!/bin/bash
# stores terraform state in network drive
# locks state by adding a lock file to the same network drive before updating state
# unlocks state by removing the lock file from the network drive after updating state
# optional logging to track all successful calls

set -e

# files to pass states and lock between terraform and command
# should match configuration in the backend.tf file
state_transfer="state_transfer"
lock_transfer="lock_transfer"

# change below to reflect your environment
# please pre-configure the network drive, and folder structure, and test access
storage_dir=/tmp/remote_fs/tf_states/resilience_app

# will be one of GET, PUT, DELETE, LOCK, UNLOCK
command=$1

# additional identifying information in debug log
runner_id=$(basename $(pwd))

# optional log file for successful operations. set to debug.
log_success(){
  if [[ ! -z $DEBUG_LOG_FILE ]]; then
    msg="$(date +"%T")   $runner_id   $command"
    echo "$msg">>$DEBUG_LOG_FILE
  fi
}
case $command in
  PUT)
    yes | cp $state_transfer $storage_dir/
    log_success
    exit 0
    ;;
  GET)
    if [[ -f $storage_dir/$state_transfer ]]; then
      yes | cp $storage_dir/$state_transfer ./
    fi
    log_success
    exit 0
    ;;
  LOCK)
    if [[ -f $storage_dir/$lock_transfer ]]; then
        cat $storage_dir/$lock_transfer
        echo "WARN. cannot obtain lock. already locked by someone."
        exit 1
    else
        set +e
        cp -n $lock_transfer $storage_dir
        exit_code=$?
        set -e
        if [[ $exit_code -ne 0 ]]; then
          cat $storage_dir/$lock_transfer
          echo "WARN. cannot obtain lock. just locked by someone."
          exit 1
        fi
    fi
    log_success
    exit 0
    ;;
  UNLOCK)
    if [[ -f $storage_dir/$lock_transfer ]]; then
        rm -f $storage_dir/$lock_transfer
    else
        echo "FAIL. lock file does not exists"
        exit 1
    fi
    log_success
    exit 0
    ;;
  DELETE)
    if [[ -f $storage_dir/$state_transfer ]]; then
        rm -f $storage_dir/$state_transfer
    else
        echo "FAIL. states file does not exists"
        exit 1
    fi
    log_success
    exit 0
    ;;
  *)
    echo "FAIL. unknow command: $command"
    exit 1
    ;;
esac
