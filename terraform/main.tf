data "yandex_compute_image" "ubuntu" {
  family = "ubuntu-2204-lts"
}

output "ubuntu_image_id" {
  value = data.yandex_compute_image.ubuntu.id
}
