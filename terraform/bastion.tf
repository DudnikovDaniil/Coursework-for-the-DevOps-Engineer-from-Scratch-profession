resource "yandex_compute_instance" "bastion" {
  name        = "bastion"
  platform_id = "standard-v3"
  zone        = "ru-central1-a"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.id
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.public.id
    security_group_ids = [yandex_vpc_security_group.bastion.id]
    nat                = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}

output "bastion_ip" {
  value = yandex_compute_instance.bastion.network_interface.0.nat_ip_address
}
