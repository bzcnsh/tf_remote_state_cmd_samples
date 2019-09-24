terraform {
  backend "artifactory" {
    username = "user_state"
    password = "P@ssw0rd"
    url      = "http://localhost:8081/artifactory"
    repo     = "TF_STATE_01"
    subpath  = "aabbaaaa/aa"
    lock_username = "user_lock"
    lock_password = "P@ssw0rd"
    unlock_username = "user_unlock"
    unlock_password = "P@ssw0rd"
    lock_url      = "http://localhost:8081/artifactory"
    lock_repo     = "TF_LOCK_01"
    lock_subpath  = "aabbaaaa/aa"
    lock_readback_wait = 100
  }
  # http://localhost:8081/artifactory/my-repository/my/new/artifact/directory/file.txt

}
