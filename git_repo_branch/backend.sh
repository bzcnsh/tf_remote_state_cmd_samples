#!/bin/bash
# stores terraform state in a git repo branch
# locks state by adding a lock file to the same branch before updating state
# unlocks state by removing the lock file from the branch after updating state
set -e

# files to pass states and lock between terraform and command
# should match configuration in the backend.tf file
state_transfer="state_transfer"
lock_transfer="lock_transfer"

# change below to reflect your environment
repo_address=https://github.com/bzcnsh/git_lock_testground.git
repo_branch=cmd_state_test
repo_local=state_local

# will be one of GET, PUT, DELETE, LOCK, UNLOCK
command=$1

# additional identifying information git commit messages
runner_id=$(basename $(pwd))

add_file_to_repo(){
  repo_dir=$1
  file=$2
  commit_msg="$3"
  err_msg="$4"
  if [[ ! -d $repo_dir ]]; then
    echo "FAIL. repo not cloned"
    exit 1
  fi
  if [[ ! -f $file ]]; then
    echo "FAIL. cannot find the file to be pushed to repo: $file"
    exit 1
  fi
  yes | cp $file $repo_dir/
  pushd $repo_dir
  git add $file
  git commit -m "$commit_msg"
  set +e
  git push origin
  exit_code=$?
  set -e
  if [[ $exit_code -ne 0 ]]; then
    echo "$err_msg"
    echo "restore local repo"
    git reset --hard HEAD^1
    exit 1
  fi
}

refresh_repo(){
  repo_dir=$1
  if [[ ! -d $repo_dir ]]; then
    echo "FAIL. repo not cloned."
    exit 1
  fi
  pushd $repo_local
  git pull origin
  popd
}

delete_file_from_repo(){
  repo_dir=$1
  file=$2
  commit_msg="$3"
  err_msg="$4"
  pushd $repo_dir
  if [[ ! -f $file ]]; then
    echo "$err_msg"
    exit 1
  fi
  git rm $file
  git commit -m "$commit_msg"
  git push origin
}

case $command in
  PUT)
    add_file_to_repo $repo_local $state_transfer "update TF states. $runner_id" "FAIL. cannot update states file. git push failed"
    exit 0
    ;;
  GET)
    if [[ ! -d $repo_local ]]; then
      git clone --depth 1 --branch $repo_branch $repo_address $repo_local
    else
      pushd $repo_local
      git checkout $repo_branch
      git pull origin
      popd
    fi
    if [[ -f $repo_local/$state_transfer ]]; then
      yes | cp $repo_local/$state_transfer ./
    fi
    exit 0
    ;;
  LOCK)
    refresh_repo $repo_local
    if [[ -f $repo_local/$lock_transfer ]]; then
        echo "WARN. cannot obtain lock. already locked."
        cat $repo_local/$lock_transfer
        exit 1
    else
        add_file_to_repo $repo_local $lock_transfer "lock. $runner_id" "FAIL. Cannot obtain lock. git push failed."
        exit 0
    fi
    ;;
  UNLOCK)
    delete_file_from_repo $repo_local $lock_transfer "unlock. $runner_id" "FAIL. Lock file not found."
    exit 0
    ;;
  DELETE)
    delete_file_from_repo $repo_local $state_transfer "delete TF state. $runner_id" "FAIL. states file not found."
    exit 0
    ;;
  *)
    echo "unknow command: $command"
    exit 1
    ;;
esac
