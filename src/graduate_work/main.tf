locals {
  network_shared_name = "vpc-shared"
  subnet_name_a       = "subnet-a"
  subnet_name_b       = "subnet-b"
  zone_a              = "ru-central1-a"
  zone_b              = "ru-central1-b"
  vm_master1_a_name   = "vm-master1-a"
  vm_master1_b_name   = "vm-master1-b"
  vm_master2_a_name   = "vm-master2-a"
  vm_worker1_a_name   = "vm-worker1-a"
  vm_worker1_b_name   = "vm-worker1-b"
  sg_nat_name         = "nat-instance-sg"
}

terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

provider "yandex" {
  token     = var.YC_TOKEN
  cloud_id  = var.YC_CLOUD_ID
  folder_id = var.YC_FOLDER_ID
  zone      = "ru-central1-a"
}

resource "yandex_iam_service_account" "sa" {
  name = "svc-acc-grd"
}

// Назначение роли сервисному аккаунту
resource "yandex_resourcemanager_folder_iam_member" "sa-editor" {
  folder_id = var.YC_FOLDER_ID
  role      = "storage.editor"
  member    = "serviceAccount:${yandex_iam_service_account.sa.id}"
}

// Создание статического ключа доступа
resource "yandex_iam_service_account_static_access_key" "sa-static-key" {
  service_account_id = yandex_iam_service_account.sa.id
  description        = "static access key for object storage"
}

// Создание бакета с использованием ключа
resource "yandex_storage_bucket" "test" {
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  bucket     = "efanov-bucket-graduate"
}

# Folders

#resource "yandex_resourcemanager_folder" "folder-a" {
#  cloud_id = var.YC_CLOUD_ID
#  name     = "folder-a"
#}
#
#resource "yandex_resourcemanager_folder" "folder-b" {
#  cloud_id = var.YC_CLOUD_ID
#  name     = "folder-b"
#}

# Creating a cloud network

resource "yandex_vpc_network" "vpc" {
  name      = local.network_shared_name
#  folder_id = yandex_resourcemanager_folder.folder-a.id
}

# Creating subnets

resource "yandex_vpc_subnet" "subnet-a" {
  name           = local.subnet_name_a
  zone           = local.zone_a
  network_id     = yandex_vpc_network.vpc.id
#  folder_id      = yandex_resourcemanager_folder.folder-a.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}

resource "yandex_vpc_subnet" "subnet-b" {
  name           = local.subnet_name_b
  zone           = local.zone_b
  network_id     = yandex_vpc_network.vpc.id
#  folder_id      = yandex_resourcemanager_folder.folder-b.id
  v4_cidr_blocks = ["192.168.11.0/24"]
}

# Creating a security group

resource "yandex_vpc_security_group" "nat-instance-sg" {
  name       = local.sg_nat_name
  network_id = yandex_vpc_network.vpc.id

  egress {
    protocol       = "ANY"
    description    = "any"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol       = "TCP"
    description    = "ssh"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 22
  }

  ingress {
    protocol       = "TCP"
    description    = "ext-http"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 80
  }

  ingress {
    protocol       = "TCP"
    description    = "ext-https"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 443
  }
}