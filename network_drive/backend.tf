terraform {
  backend "cmd" {
    base_command = "./backend.sh"
    state_transfer_file = "state_transfer"
    lock_transfer_file = "lock_transfer"
  }
}
