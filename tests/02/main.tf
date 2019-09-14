resource "local_file" "01" {
    content     = "01"
    filename = "/tmp/local_file_test.01"
}

resource "local_file" "03" {
    content     = "03"
    filename = "/tmp/local_file_test.03"
}

output "local_file_01_id" {
  value = "${local_file.01.id}"
}
output "local_file_03_id" {
  value = "${local_file.03.id}"
}
