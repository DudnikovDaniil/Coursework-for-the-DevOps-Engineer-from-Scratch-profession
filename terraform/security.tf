# Bastion Security Group
resource "yandex_vpc_security_group" "bastion" {
  name       = "bastion-sg"
  network_id = yandex_vpc_network.diploma.id

  ingress {
    protocol       = "TCP"
    port           = 22
    v4_cidr_blocks = ["0.0.0.0/0"]
    description    = "SSH"
  }

  egress {
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

# Web Servers Security Group
resource "yandex_vpc_security_group" "web" {
  name       = "web-sg"
  network_id = yandex_vpc_network.diploma.id

  ingress {
    protocol       = "TCP"
    port           = 22
    v4_cidr_blocks = ["10.10.1.0/24", "10.10.2.0/24", "10.20.2.0/24"]
    description    = "SSH from internal"
  }

  ingress {
    protocol       = "TCP"
    port           = 80
    v4_cidr_blocks = ["0.0.0.0/0"]
    description    = "HTTP"
  }

  egress {
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  # Разрешаем доступ от Prometheus к Node Exporter
  ingress {
    protocol       = "TCP"
    port           = 9100
    v4_cidr_blocks = ["10.10.2.19/32"]
    description    = "Prometheus Node Exporter access"
  }

  # Разрешаем доступ от Prometheus к Nginx Exporter
  ingress {
    protocol       = "TCP"
    port           = 9113
    v4_cidr_blocks = ["10.10.2.19/32"]
    description    = "Prometheus Nginx Exporter access"
  }
}
