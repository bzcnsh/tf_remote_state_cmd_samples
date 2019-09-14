resource "local_file" "01" {
    content     = "01"
    filename = "/tmp/local_file_test.01"
}

resource "local_file" "04" {
    content     = "04"
    filename = "/tmp/local_file_test.04"
}

output "local_file_01_id" {
  value = "${local_file.01.id}"
}
output "local_file_04_id" {
  value = "${local_file.04.id}"
}
