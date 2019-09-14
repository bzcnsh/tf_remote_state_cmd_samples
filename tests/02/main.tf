resource "local_file" "f00" {
    content     = "${timestamp()}"
    filename = "/tmp/local_file_test.00"
}

resource "local_file" "f02" {
    content     = "${timestamp()}"
    filename = "/tmp/local_file_test.02"
}

output "local_file_00_id" {
  value = "${local_file.f00.id}"
}
output "local_file_02_id" {
  value = "${local_file.f02.id}"
}
