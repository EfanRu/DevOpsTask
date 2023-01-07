variable "YC_TOKEN" {
  type = string
}

variable "YC_CLOUD_ID" {
  type = string
}

variable "YC_FOLDER_ID" {
  type = string
}

locals {
  image_id = {
    stage = yandex_compute_image.ubuntu_2004.id,
    prod  = yandex_compute_image.ubuntu-20-04-lts.id
  }
}