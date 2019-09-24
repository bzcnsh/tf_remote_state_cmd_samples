# sample scripts to work with *cmd* type terraform remote state

## overview:
With the `cmd` type, the locking and storing of state is delegated to an external command. Terraform calls the command with one of the 'GET', 'PUT', 'DELETE', 'LOCK', 'UNLOCK' subcommands. The content of state and lock is passed between terraform and the command in separate files.

With the `cmd` type remote state, you can write your own script tailored to your own environment to keep your terraform state in a shareable and lockable manner.

## sample commands:
### network_drive: script to keep state and lock on a network drive
### git_repo_branch: script to keep state and lock in a git repo branch
### all others: configuration for backend types not related to `cmd`, but kept here to share the testing framework.

## how to run tests:
`./test_runner.sh <sample_script_directory> <duration_in_seconds>`

like so:
`./test_runner.sh network_drive 1800`

to have 3 processes compete to run "terraform apply" at the same time for 1800 seconds.

make sure to update the backend.sh in network_drive folder to reflect your environment. before firing up the test_runner.

## how to check test results?

### Option 1: extract trace of success operations from log file
```
grep -H -r "remote-state/" workspace/*/trace.log | grep TRACE | sort -k 2 | sed -e 's/workspace\///g' -e 's/\/trace.log:/ /g' -e 's/\[TRACE\] backend\/remote-state\/cmd://g'  | grep success
```
Output:
```
process_id timestamp message
01 2019/09/24 07:58:37  exiting Get operation with success
02 2019/09/24 07:58:37  exiting Get operation with success
03 2019/09/24 07:58:37  exiting Get operation with success
03 2019/09/24 07:58:48  exiting Get operation with success
03 2019/09/24 07:58:48  exiting Lock operation with success
03 2019/09/24 07:58:51  exiting Put operation with success
03 2019/09/24 07:58:54  exiting Get operation with success
03 2019/09/24 07:58:54  exiting Unlock operation with success
02 2019/09/24 07:58:57  exiting Get operation with success
02 2019/09/24 07:58:57  exiting Lock operation with success
03 2019/09/24 07:58:58  exiting Get operation with success
03 2019/09/24 07:58:59  exiting Get operation with success
03 2019/09/24 07:59:01  exiting Get operation with success
02 2019/09/24 07:59:01  exiting Put operation with success
03 2019/09/24 07:59:02  exiting Get operation with success
03 2019/09/24 07:59:03  exiting Get operation with success
02 2019/09/24 07:59:03  exiting Unlock operation with success
02 2019/09/24 07:59:04  exiting Get operation with success
02 2019/09/24 07:59:07  exiting Get operation with success
03 2019/09/24 07:59:07  exiting Get operation with success
02 2019/09/24 07:59:07  exiting Lock operation with success
03 2019/09/24 07:59:08  exiting Get operation with success
03 2019/09/24 07:59:08  exiting Get operation with success
......
```

Between a process' `Lock` and the next `Unlock` from the same process, only `Put` from the process, and `Get` from any process should exit with success. The reading might be inaccurate when multiple operations happen in the same second , more granular timestamp is needed.

### Option 2: use the <DEBUG_LOG_FILE> defined in `test_runner.sh`

e.g. $ cat /tmp/git_repo_branch.log:
```
time     process command
...
17:22:03   03   GET
17:22:05   02   LOCK
17:22:05   02   GET
17:22:06   01   GET
17:22:06   03   GET
17:22:09   02   PUT
17:22:10   01   GET
17:22:10   03   GET
17:22:12   02   UNLOCK
17:22:12   02   GET
17:22:15   01   LOCK
17:22:15   01   GET
17:22:18   03   GET
17:22:18   01   PUT
17:22:20   01   UNLOCK
17:22:21   01   GET
17:22:23   02   LOCK
```

Between a process' `LOCK` and the next `UNLOCK` from the same process, only `PUT` from the process, and `GET` from any processes are allowed.
