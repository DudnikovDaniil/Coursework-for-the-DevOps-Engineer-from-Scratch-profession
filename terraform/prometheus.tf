# Security Group для Prometheus
resource "yandex_vpc_security_group" "prometheus" {
  name       = "prometheus-sg"
  network_id = yandex_vpc_network.diploma.id

  # Разрешаем доступ от Grafana
  ingress {
    protocol       = "TCP"
    port           = 9090
    v4_cidr_blocks = ["10.10.1.0/24"]
    description    = "Access from public subnet"
  }

  # Входящий SSH с bastion
  ingress {
    protocol       = "TCP"
    port           = 22
    v4_cidr_blocks = ["10.10.1.0/24", "10.10.2.0/24", "10.20.2.0/24"]
    description    = "SSH from internal"
  }

  # Входящие метрики от Node Exporter (только от web серверов)
  ingress {
    protocol       = "TCP"
    port           = 9100
    v4_cidr_blocks = ["10.10.2.0/24", "10.20.2.0/24"]
    description    = "Node Exporter metrics"
  }

  # Входящие метрики от Nginx Exporter
  ingress {
    protocol       = "TCP"
    port           = 9113
    v4_cidr_blocks = ["10.10.2.0/24", "10.20.2.0/24"]
    description    = "Nginx Exporter metrics"
  }

  # Исходящий трафик
  egress {
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

# ВМ для Prometheus
resource "yandex_compute_instance" "prometheus" {
  name        = "prometheus"
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
    subnet_id          = yandex_vpc_subnet.private_a.id
    security_group_ids = [yandex_vpc_security_group.prometheus.id]
    nat                = false
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}\nubuntu:${file("./bastion_key.pub")}"
  }
}

output "prometheus_ip" {
  value = yandex_compute_instance.prometheus.network_interface.0.ip_address
}
