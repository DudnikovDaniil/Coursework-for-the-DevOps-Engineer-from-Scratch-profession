resource "yandex_vpc_network" "diploma" {
  name = "diploma-network"
}

resource "yandex_vpc_subnet" "public" {
  name           = "public"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.diploma.id
  v4_cidr_blocks = ["10.10.1.0/24"]
}

resource "yandex_vpc_subnet" "private_a" {
  name           = "private-a"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.diploma.id
  v4_cidr_blocks = ["10.10.2.0/24"]
  route_table_id = yandex_vpc_route_table.nat_route.id
}

resource "yandex_vpc_subnet" "private_b" {
  name           = "private-b"
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.diploma.id
  v4_cidr_blocks = ["10.20.2.0/24"]
  route_table_id = yandex_vpc_route_table.nat_route.id
}
