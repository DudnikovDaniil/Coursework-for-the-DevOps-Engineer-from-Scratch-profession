# Coursework for the "DevOps Engineer from Scratch" profession

  ##  Отказоустойчивая инфраструктура в Yandex Cloud

  **Работу выполнил:** Дудников Даниил

##  Инфраструктура в Yandex Cloud

##  **Содержание**
- [О проекте](#-о-проекте)
- [Технологии](#-технологии)
- [IP адреса и доступы](#-ip-адреса-и-доступы)
- [Скриншоты](#-скриншоты)
- [Заключение](#-заключение)
---

##  **О проекте**

Цель работы — разработать **отказоустойчивую инфраструктуру** для сайта с мониторингом, сбором логов и резервным копированием в **Yandex Cloud**.

### Ключевые особенности:
- Два web-сервера в разных зонах доступности
- Балансировка трафика через Application Load Balancer
- Bastion host для безопасного доступа
- Полный мониторинг (Prometheus + Grafana)
- Резервное копирование (snapshots)

---

##  **IP адреса и доступы**

**Сайт** — `89.169.149.74` (балансировщик) 
**Grafana** — `89.169.149.43:3000` (admin/admin) 
**Bastion** — `89.169.137.73` (SSH gateway) 
**WEB1** — `10.10.2.24` (внутренний) 
**WEB2** — `10.20.2.32` (внутренний) 
**Prometheus** — `10.10.2.19` (внутренний)

##  Скриншоты

###  Этап 1: Базовая инфраструктура
- [`01-balancer-site.png`](./screenshots/01-balancer-site.png) — сайт через балансировщик
- [`02-load-balancing.png`](./screenshots/02-load-balancing.png) — балансировка между серверами
- [`03-vm-list.png`](./screenshots/03-vm-list.png) — список всех ВМ
- [`04-alb-details.png`](./screenshots/04-alb-details.png) — детали балансировщика
- [`05-terraform-resources.png`](./screenshots/05-terraform-resources.png) — ресурсы Terraform
- [`06-ansible-ping.png`](./screenshots/06-ansible-ping.png) — Ansible ping до всех хостов
- [`07-nginx-status.png`](./screenshots/07-nginx-status.png) — статус nginx на web1
- [`08-network-subnets.png`](./screenshots/08-network-subnets.png) — сеть и подсети
- [`09-ssh-access.png`](./screenshots/09-ssh-access.png) — доступ к bastion
- [`10-terraform-outputs.png`](./screenshots/10-terraform-outputs.png) — outputs Terraform
- [`11-yc-resources-overview.png`](./screenshots/11-yc-resources-overview.png) — обзор ресурсов в YC

###  Этап 2: Мониторинг
- [`12-dashboard-node-exporter.png`](./screenshots/12-dashboard-node-exporter.png) — дашборд Node Exporter
- [`13-dashboard-nginx.png`](./screenshots/13-dashboard-nginx.png) — дашборд Nginx
- [`14-explore-up.png`](./screenshots/14-explore-up.png) — запрос up в Explore
- [`15-prometheus-targets.png`](./screenshots/15-prometheus-targets.png) — таргеты Prometheus
- [`16-grafana-datasource.png`](./screenshots/16-grafana-datasource.png) — источник данных в Grafana
- [`17-load-balancer-test.png`](./screenshots/17-load-balancer-test.png) — тест балансировщика
- [`18-yc-vm-list.png`](./screenshots/18-yc-vm-list.png) — все ВМ в Yandex Cloud
- [`19-terraform-state.png`](./screenshots/19-terraform-state.png) — состояние Terraform
- [`20-ansible-ping-final.png`](./screenshots/20-ansible-ping-final.png) — финальный Ansible ping

###  Этап 3: Резервное копирование
- [`21-backup-policy.png`](./screenshots/21-backup-policy.png) — политика снапшотов
---

##  Используемые технологии
- **Terraform** - управление инфраструктурой
- **Ansible** - настройка серверов
- **Yandex Cloud** - облачная платформа
- **Prometheus** - сбор метрик
- **Grafana** - визуализация
- **Nginx** - веб-сервер

##  **Заключение**

Этот проект стал для меня настоящим вызовом. Было непросто: ошибки в конфигах, проблемы с сетью, пляски с security groups, бессонные ночи за отладкой... Но когда всё заработало — балансировщик распределил трафик, Grafana показала первые графики, а снапшоты создались по расписанию — чувство удовлетворения перекрыло всё!

**Особая благодарность** — руководителям и наставникам за их терпение и готовность всегда помочь.

Этот проект научил меня не сдаваться, гуглить, экспериментировать и доводить дело до конца.
