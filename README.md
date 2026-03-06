# Курсовая работа на профессии "DevOps-инженер с нуля"

## Отказоустойчивая инфраструктура в Yandex Cloud

**Работу выполнил:** Дудников Даниил

##  **Содержание**
- [О проекте](#о-проекте)
- [Структура репозитория](#структура-репозитория)
- [Технологии](#технологии)
- [IP адреса и доступы](#ip-адреса-и-доступы)
- [Инструкция по развертыванию](#инструкция-по-развертыванию)
- [Скриншоты](#скриншоты)
- [Заключение](#заключение)

---

## **О проекте** <a id="о-проекте"></a>

Цель работы — разработать **отказоустойчивую инфраструктуру** для сайта с мониторингом, сбором логов и резервным копированием в **Yandex Cloud**.

### Ключевые особенности:
- Два web-сервера в разных зонах доступности
- Балансировка трафика через Application Load Balancer
- Bastion host для безопасного доступа
- Полный мониторинг (Prometheus + Grafana)
- Резервное копирование (snapshots)

*В ходе работы была полностью развернута отказоустойчивая инфраструктура в Yandex Cloud с использованием Terraform и Ansible. Все манифесты и плейбуки приложены в репозитории. Для воспроизведения достаточно выполнить инструкцию из README, подставив свои токены и ID.*
---

##  **Структура репозитория** <a id="структура-репозитория"></a>

<img src="https://github.com/DudnikovDaniil/Coursework-for-the-DevOps-Engineer-from-Scratch-profession/raw/main/screenshots/22-repo-structure.png" width="700">

##  **Технологии** <a id="технологии"></a>
**Terraform** · **Ansible** · **Yandex Cloud** · **Prometheus** · **Grafana** · **Nginx** · **Ubuntu**

---

##  **IP адреса и доступы** <a id="ip-адреса-и-доступы"></a>
**Сайт** — `89.169.149.74` (балансировщик) 
**Grafana** — `89.169.149.43:3000` (admin/admin) 
**Bastion** — `89.169.137.73` (SSH gateway) 
**WEB1** — `10.10.2.24` (внутренний) 
**WEB2** — `10.20.2.32` (внутренний) 
**Prometheus** — `10.10.2.19` (внутренний)

---

##  **Инструкция по развертыванию** <a id="инструкция-по-развертыванию"></a>

### 1. Предварительные требования
- Установленный [Terraform](https://www.terraform.io/downloads)
- Установленный [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)
- [Yandex Cloud CLI](https://cloud.yandex.ru/docs/cli/quickstart)
- SSH ключи (публичный/приватный)

### 2. Клонирование репозитория
```bash
git clone https://github.com/DudnikovDaniil/Coursework-for-the-DevOps-Engineer-from-Scratch-profession.git
cd Coursework-for-the-DevOps-Engineer-from-Scratch-profession
```

### 3. Настройка Terraform
```bash
cd terraform
cp terraform.tfvars.example terraform.tfvars
```
Отредактируйте `terraform.tfvars`, вставьте свои данные:
```bash
yandex_token = "ваш_oauth_токен"
cloud_id     = "ваш_cloud_id"
folder_id    = "ваш_folder_id"
default_zone = "ru-central1-a"
```

### 4. Развертывание инфраструктуры
```bash
terraform init
terraform plan
terraform apply -auto-approve
```
Сохраните IP адреса из вывода команды:
```bash
terraform output
```

### 5. Настройка Ansible
```bash
cd ../ansible
cp inventory.ini.example inventory.ini
```
Отредактируйте `inventory.ini`, вставьте реальные IP адреса:
```bash
[bastion]
bastion ansible_host=<bastion_public_ip> ansible_user=ubuntu

[web]
web1 ansible_host=<web1_private_ip> ansible_user=ubuntu
web2 ansible_host=<web2_private_ip> ansible_user=ubuntu

[prometheus]
prometheus ansible_host=<prometheus_private_ip> ansible_user=ubuntu

[grafana]
grafana ansible_host=<grafana_public_ip> ansible_user=ubuntu

[all:vars]
ansible_ssh_private_key_file=~/.ssh/id_rsa
ansible_ssh_common_args='-o ProxyCommand="ssh -W %h:%p -i ~/.ssh/id_rsa ubuntu@<bastion_public_ip>"'
```

### 6. Установка ПО на серверы
```bash
ansible-playbook -i inventory.ini install_nginx.yml
ansible-playbook -i inventory.ini exporters.yml
ansible-playbook -i inventory.ini prometheus.yml
ansible-playbook -i inventory.ini grafana.yml
```

### 7. Проверка результатов
- **Сайт**: `http://<balancer_ip>`
- **Grafana**: `http://<grafana_ip>:3000` (логин/пароль: admin/admin)
- **Prometheus**: `http://<prometheus_ip>:9090` (доступ через bastion)

##  **Скриншоты** <a id="скриншоты"></a>

###  Этап 1: Базовая инфраструктура

<img src="https://github.com/DudnikovDaniil/Coursework-for-the-DevOps-Engineer-from-Scratch-profession/raw/main/screenshots/01-balancer-site.png" width="600">
*01 — сайт через балансировщик*

<img src="https://github.com/DudnikovDaniil/Coursework-for-the-DevOps-Engineer-from-Scratch-profession/raw/main/screenshots/02-load-balancing.png" width="600">
*02 — балансировка между серверами*

<img src="https://github.com/DudnikovDaniil/Coursework-for-the-DevOps-Engineer-from-Scratch-profession/raw/main/screenshots/03-vm-list.png" width="600">
*03 — список всех ВМ*

<img src="https://github.com/DudnikovDaniil/Coursework-for-the-DevOps-Engineer-from-Scratch-profession/raw/main/screenshots/04-alb-details.png" width="600">
*04 — детали балансировщика*

<img src="https://github.com/DudnikovDaniil/Coursework-for-the-DevOps-Engineer-from-Scratch-profession/raw/main/screenshots/05-terraform-resources.png" width="600">
*05 — ресурсы Terraform*

<img src="https://github.com/DudnikovDaniil/Coursework-for-the-DevOps-Engineer-from-Scratch-profession/raw/main/screenshots/06-ansible-ping.png" width="600">
*06 — Ansible ping до всех хостов*

<img src="https://github.com/DudnikovDaniil/Coursework-for-the-DevOps-Engineer-from-Scratch-profession/raw/main/screenshots/07-nginx-status.png" width="600">
*07 — статус nginx на web1*

<img src="https://github.com/DudnikovDaniil/Coursework-for-the-DevOps-Engineer-from-Scratch-profession/raw/main/screenshots/08-network-subnets.png" width="600">
*08 — сеть и подсети*

<img src="https://github.com/DudnikovDaniil/Coursework-for-the-DevOps-Engineer-from-Scratch-profession/raw/main/screenshots/09-ssh-access.png" width="600">
*09 — доступ к bastion*

<img src="https://github.com/DudnikovDaniil/Coursework-for-the-DevOps-Engineer-from-Scratch-profession/raw/main/screenshots/10-terraform-outputs.png" width="600">
*10 — outputs Terraform*

<img src="https://github.com/DudnikovDaniil/Coursework-for-the-DevOps-Engineer-from-Scratch-profession/raw/main/screenshots/11-yc-resources-overview.png" width="600">
*11 — обзор ресурсов в YC*

###  Этап 2: Мониторинг

<img src="https://github.com/DudnikovDaniil/Coursework-for-the-DevOps-Engineer-from-Scratch-profession/raw/main/screenshots/12-dashboard-node-exporter.png" width="600">
*12 — дашборд Node Exporter*

<img src="https://github.com/DudnikovDaniil/Coursework-for-the-DevOps-Engineer-from-Scratch-profession/raw/main/screenshots/13-dashboard-nginx.png" width="600">
*13 — дашборд Nginx*

<img src="https://github.com/DudnikovDaniil/Coursework-for-the-DevOps-Engineer-from-Scratch-profession/raw/main/screenshots/14-explore-up.png" width="600">
*14 — запрос up в Explore*

<img src="https://github.com/DudnikovDaniil/Coursework-for-the-DevOps-Engineer-from-Scratch-profession/raw/main/screenshots/15-prometheus-targets.png" width="600">
*15 — таргеты Prometheus*

<img src="https://github.com/DudnikovDaniil/Coursework-for-the-DevOps-Engineer-from-Scratch-profession/raw/main/screenshots/16-grafana-datasource.png" width="600">
*16 — источник данных в Grafana*

<img src="https://github.com/DudnikovDaniil/Coursework-for-the-DevOps-Engineer-from-Scratch-profession/raw/main/screenshots/17-load-balancer-test.png" width="600">
*17 — тест балансировщика*

<img src="https://github.com/DudnikovDaniil/Coursework-for-the-DevOps-Engineer-from-Scratch-profession/raw/main/screenshots/18-yc-vm-list.png" width="600">
*18 — все ВМ в Yandex Cloud*

<img src="https://github.com/DudnikovDaniil/Coursework-for-the-DevOps-Engineer-from-Scratch-profession/raw/main/screenshots/19-terraform-state.png" width="600">
*19 — состояние Terraform*

<img src="https://github.com/DudnikovDaniil/Coursework-for-the-DevOps-Engineer-from-Scratch-profession/raw/main/screenshots/20-ansible-ping-final.png" width="600">
*20 — финальный Ansible ping*

###  Этап 3: Резервное копирование

<img src="https://github.com/DudnikovDaniil/Coursework-for-the-DevOps-Engineer-from-Scratch-profession/raw/main/screenshots/21-backup-policy.png" width="600">
*21 — политика снапшотов*

---

##  Используемые технологии
- **Terraform** - управление инфраструктурой
- **Ansible** - настройка серверов
- **Yandex Cloud** - облачная платформа
- **Prometheus** - сбор метрик
- **Grafana** - визуализация
- **Nginx** - веб-сервер

---

##  **Заключение** <a id="заключение"></a>

Этот проект стал для меня настоящим вызовом. Было непросто: ошибки в конфигах, проблемы с сетью, пляски с security groups, бессонные ночи за отладкой... Но когда всё заработало — балансировщик распределил трафик, Grafana показала первые графики, а снапшоты создались по расписанию — чувство удовлетворения перекрыло всё!

**Особая благодарность** — руководителям и наставникам за их терпение и готовность всегда помочь.

Этот проект научил меня не сдаваться, гуглить, экспериментировать и доводить дело до конца.

---

<div align="center">

  [В начало](#курсовая-работа-на-профессии-devops-инженер-с-нуля)

</div>
