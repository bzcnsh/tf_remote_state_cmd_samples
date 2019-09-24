terraform {
  backend "artifactory" {
    username = "admin"
    password = "admin123"
    url      = "http://localhost:8082/content/repositories"
    repo     = "TF_STATE"
    subpath  = "aabbaaaa/aa"
    lock_username = "admin"
    lock_password = "admin123"
    lock_url      = "http://localhost:8082/content/repositories"
    lock_repo     = "TF_LOCK"
    lock_subpath  = "aabbaaaa/aa"
    lock_readback_wait = 200
  }
}
