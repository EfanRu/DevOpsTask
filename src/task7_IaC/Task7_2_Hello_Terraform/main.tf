provider "yandex" {
  token                    = var.YC_TOKEN
  cloud_id                 = var.YC_CLOUD_ID
  folder_id                = var.YC_FOLDER_ID
  zone                     = "ru-central1-a"
}