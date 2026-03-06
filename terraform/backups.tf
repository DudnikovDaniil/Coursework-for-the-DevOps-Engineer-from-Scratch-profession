# Создаем snapshot policy для всех дисков
resource "yandex_compute_snapshot_schedule" "daily_backup" {
  name = "daily-backup"

  schedule_policy {
    expression = "0 0 * * *" # Каждый день в 00:00
  }

  retention_period = "168h" # 7 дней (1 неделя)

  snapshot_count = 7 # Хранить 7 снапшотов

  disk_ids = [
    yandex_compute_instance.bastion.boot_disk[0].disk_id,
    yandex_compute_instance.nat.boot_disk[0].disk_id,
    yandex_compute_instance.web1.boot_disk[0].disk_id,
    yandex_compute_instance.web2.boot_disk[0].disk_id,
    yandex_compute_instance.prometheus.boot_disk[0].disk_id,
    yandex_compute_instance.grafana.boot_disk[0].disk_id
  ]

  labels = {
    environment = "diploma"
    backup      = "daily"
  }
}

output "snapshot_schedule_id" {
  value = yandex_compute_snapshot_schedule.daily_backup.id
}
