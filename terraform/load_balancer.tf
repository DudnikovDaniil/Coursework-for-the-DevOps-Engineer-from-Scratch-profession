# Создаем внешний IP для балансировщика
resource "yandex_vpc_address" "load_balancer_ip" {
  name = "load-balancer-ip"
  external_ipv4_address {
    zone_id = "ru-central1-a"
  }
}

# Target Group для web серверов
resource "yandex_alb_target_group" "web" {
  name = "web-target-group"

  target {
    subnet_id = yandex_vpc_subnet.private_a.id
    ip_address = yandex_compute_instance.web1.network_interface.0.ip_address
  }

  target {
    subnet_id = yandex_vpc_subnet.private_b.id
    ip_address = yandex_compute_instance.web2.network_interface.0.ip_address
  }
}

# Backend Group
resource "yandex_alb_backend_group" "web" {
  name = "web-backend-group"

  http_backend {
    name = "web-backend"
    port = 80
    target_group_ids = [yandex_alb_target_group.web.id]

    healthcheck {
      timeout = "1s"
      interval = "2s"
      healthy_threshold = 2
      unhealthy_threshold = 2
      http_healthcheck {
        path = "/"
      }
    }
  }
}

# HTTP Router
resource "yandex_alb_http_router" "web" {
  name = "web-http-router"
}

# Virtual Host
resource "yandex_alb_virtual_host" "web" {
  name = "web-virtual-host"
  http_router_id = yandex_alb_http_router.web.id
  authority = ["*"]

  route {
    name = "web-route"
    http_route {
      http_match {
        path {
          prefix = "/"
        }
      }
      http_route_action {
        backend_group_id = yandex_alb_backend_group.web.id
        timeout = "3s"
      }
    }
  }
}

# Application Load Balancer
resource "yandex_alb_load_balancer" "web" {
  name = "web-load-balancer"
  network_id = yandex_vpc_network.diploma.id

  allocation_policy {
    location {
      zone_id = "ru-central1-a"
      subnet_id = yandex_vpc_subnet.public.id
    }
  }

  listener {
    name = "web-listener"
    endpoint {
      ports = [80]
      address {
        external_ipv4_address {
          address = yandex_vpc_address.load_balancer_ip.external_ipv4_address[0].address
        }
      }
    }
    http {
      handler {
        http_router_id = yandex_alb_http_router.web.id
      }
    }
  }

  log_options {
    disable = true
  }
}

output "load_balancer_ip" {
  value = yandex_vpc_address.load_balancer_ip.external_ipv4_address[0].address
}
