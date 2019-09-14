resource "local_file" "01" {
    content     = "01"
    filename = "/tmp/local_file_test.01"
}

resource "local_file" "02" {
    content     = "02"
    filename = "/tmp/local_file_test.02"
}

output "local_file_01_id" {
  value = "${local_file.01.id}"
}
output "local_file_02_id" {
  value = "${local_file.02.id}"
}
