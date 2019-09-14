## sample scripts for *cmd* type terraform remote state

# overview
With the `cmd` type, the locking and storing of state is delegated to an external command. Terraform calls the command with one of the 'GET', 'PUT', 'DELETE', 'LOCK', 'UNLOCK' subcommands. The content of state and lock is passed between terraform and the command in separate files.
With the `cmd` type remote state, you can write your own script tailored to your own environment to keep your terraform state in a shareable and lockable manner.

# sample: network_drive
Sample script to keep state and lock on a network drive

# sample: git_repo_branch
Sample script to keep state and lock in a git repo branch
