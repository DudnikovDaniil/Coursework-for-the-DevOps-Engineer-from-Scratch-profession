# Security Group для Grafana
resource "yandex_vpc_security_group" "grafana" {
  name       = "grafana-sg"
  network_id = yandex_vpc_network.diploma.id

  # Входящий SSH с bastion (внутренние сети)
  ingress {
    protocol       = "TCP"
    port           = 22
    v4_cidr_blocks = ["10.10.1.0/24", "10.10.2.0/24", "10.20.2.0/24"]
    description    = "SSH from internal"
  }

  # Входящий SSH с внешнего IP (для администрирования)
  ingress {
    protocol       = "TCP"
    port           = 22
    v4_cidr_blocks = ["0.0.0.0/0"]
    description    = "SSH from anywhere (temporary)"
  }

  # Входящий HTTP для Grafana (порт 3000)
  ingress {
    protocol       = "TCP"
    port           = 3000
    v4_cidr_blocks = ["0.0.0.0/0"]
    description    = "Grafana web interface"
  }

  # Исходящий трафик
  egress {
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

# ВМ для Grafana
resource "yandex_compute_instance" "grafana" {
  name        = "grafana"
  platform_id = "standard-v3"
  zone        = "ru-central1-a"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.id
      size     = 20
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.public.id
    security_group_ids = [yandex_vpc_security_group.grafana.id]
    nat                = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}\nubuntu:${file("./bastion_key.pub")}"
  }
}

output "grafana_ip" {
  value = yandex_compute_instance.grafana.network_interface.0.nat_ip_address
}
