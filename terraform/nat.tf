# Создаем NAT инстанс в публичной подсети
resource "yandex_compute_instance" "nat" {
  name        = "nat"
  platform_id = "standard-v3"
  zone        = "ru-central1-a"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd80mrhj8fl2oe87o4e1"  # NAT Instance image
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.public.id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}

# Создаем таблицу маршрутизации для приватных подсетей
resource "yandex_vpc_route_table" "nat_route" {
  name       = "nat-route"
  network_id = yandex_vpc_network.diploma.id

  static_route {
    destination_prefix = "0.0.0.0/0"
    next_hop_address   = yandex_compute_instance.nat.network_interface.0.ip_address
  }
}
