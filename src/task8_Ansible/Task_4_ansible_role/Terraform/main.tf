provider "yandex" {
  token                    = var.YC_TOKEN
  cloud_id                 = var.YC_CLOUD_ID
  folder_id                = var.YC_FOLDER_ID
  zone                     = "ru-central1-a"
}

output "internal_ip_address_clickhouse-01" {
  value = yandex_compute_instance.clickhouse-01.network_interface.0.ip_address
}

output "internal_ip_address_vector-01" {
  value = yandex_compute_instance.vector-01.network_interface.0.ip_address
}

output "internal_ip_address_lighthouse-01" {
  value = yandex_compute_instance.lighthouse-01.network_interface.0.ip_address
}

output "external_ip_address_clickhouse-01" {
  value = yandex_compute_instance.clickhouse-01.network_interface.0.nat_ip_address
}

output "external_ip_address_vector-01" {
  value = yandex_compute_instance.vector-01.network_interface.0.nat_ip_address
}

output "external_ip_address_lighthouse-01" {
  value = yandex_compute_instance.lighthouse-01.network_interface.0.nat_ip_address
}