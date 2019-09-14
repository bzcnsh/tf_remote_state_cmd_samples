resource "local_file" "f00" {
    content     = "${timestamp()}"
    filename = "/tmp/local_file_test.00"
}

resource "local_file" "f03" {
    content     = "${timestamp()}"
    filename = "/tmp/local_file_test.03"
}

output "local_file_00_id" {
  value = "${local_file.f00.id}"
}
output "local_file_03_id" {
  value = "${local_file.f03.id}"
}
