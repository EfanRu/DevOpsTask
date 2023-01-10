terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  
  backend "s3" {
    endpoint   = "storage.yandexcloud.net"
    bucket     = "my-bucket-by-slava"
    region     = "ru-central1"
    key        = "my_first_tfstate_file.tfstate"
    access_key = "xxx"
    secret_key = "xxx"

    skip_region_validation      = true
    skip_credentials_validation = true
  }
  
  required_version = ">= 0.13"
}
