## sample scripts to work with *cmd* type terraform remote state

# overview
With the `cmd` type, the locking and storing of state is delegated to an external command. Terraform calls the command with one of the 'GET', 'PUT', 'DELETE', 'LOCK', 'UNLOCK' subcommands. The content of state and lock is passed between terraform and the command in separate files.

With the `cmd` type remote state, you can write your own script tailored to your own environment to keep your terraform state in a shareable and lockable manner.

# sample: network_drive
Sample script to keep state and lock on a network drive

# sample: git_repo_branch
Sample script to keep state and lock in a git repo branch

# how to run tests:
`./test_runner.sh <sample_script_directory> <duration_in_seconds>`

like so:
`./test_runner.sh network_drive 1800`

to have 3 processes compete to run "terraform apply" at the same time for 1800 seconds.

make sure to update the backend.sh in network_drive folder to reflect your environment. before firing up the test_runner.

# how to check test results?
Open test_runner.sh. It defines a `DEBUG_LOG_FILE` file, which tracks all the successful operations performed by the `backend.sh`.

Like so:
```
time     runner command
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

Between a runner's LOCK command and the next UNLOCK command from the same runner, only GET from any runner, and PUT from the same runner is allowed.

This can be scripted...
