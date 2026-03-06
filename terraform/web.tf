resource "yandex_compute_instance" "web1" {
  name        = "web1"
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
    subnet_id          = yandex_vpc_subnet.private_a.id
    security_group_ids = [yandex_vpc_security_group.web.id]
    nat                = false
  }

  metadata = {
    ssh-keys = <<-EOT
      ubuntu:${file("./local_key.pub")}
      ubuntu:${file("./bastion_key.pub")}
    EOT
  }
}

resource "yandex_compute_instance" "web2" {
  name        = "web2"
  platform_id = "standard-v3"
  zone        = "ru-central1-b"

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
    subnet_id          = yandex_vpc_subnet.private_b.id
    security_group_ids = [yandex_vpc_security_group.web.id]
    nat                = false
  }

  metadata = {
    ssh-keys = <<-EOT
      ubuntu:${file("./local_key.pub")}
      ubuntu:${file("./bastion_key.pub")}
    EOT
  }
}

output "web1_ip" {
  value = yandex_compute_instance.web1.network_interface.0.ip_address
}

output "web2_ip" {
  value = yandex_compute_instance.web2.network_interface.0.ip_address
}
