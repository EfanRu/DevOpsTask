terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  
  backend "s3" {
    endpoint   = "storage.yandexcloud.net"
    bucket     = "my-first-bucket-by-slava"
    region     = "ru-central1"
    key        = "my_first_tfstate_file.tfstate"
    access_key =
    secret_key =

    skip_region_validation      = true
    skip_credentials_validation = true
  }
  
  required_version = ">= 0.13"
}
