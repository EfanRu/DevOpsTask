locals {
  network_name        = "graduate-vpc"
  subnet_name_master1_a = "subnet-master1-a"
  subnet_name_master1_b = "subnet-master1-b"
  subnet_name_master2_a = "subnet-master2-a"
  subnet_name_worker1_a = "subnet-worker1-a"
  subnet_name_worker1_b = "subnet-worker1-b"
  vm_master1_a_name     = "vm-master1-a"
  vm_master1_b_name     = "vm-master1-b"
  vm_master2_a_name     = "vm-master2-a"
  vm_worker1_a_name     = "vm-worker1-a"
  vm_worker1_b_name     = "vm-worker1-b"
  sg_nat_name           = "nat-instance-sg"
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

# Creating a cloud network

#module "yc-vpc" {
#  source              = "github.com/terraform-yc-modules/terraform-yc-vpc.git"
#  network_name        = local.network_name
#  network_description = "Graduate DevOps network created with module"
#  private_subnets = [{
#    name           = local.subnet_name_a
#    zone           = "ru-central1-a"
#    v4_cidr_blocks = ["10.10.0.0/24"]
#  },
#  {
#    name           = local.subnet_name_b
#    zone           = "ru-central1-b"
#    v4_cidr_blocks = ["10.11.0.0/24"]
#  }]
#}

resource "yandex_vpc_network" "vpc" {
  name = local.network_name
}

# Creating subnets

resource "yandex_vpc_subnet" "subnet-master1-a" {
  name           = local.subnet_name_master1_a
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.vpc.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}

resource "yandex_vpc_subnet" "subnet-master1-b" {
  name           = local.subnet_name_master1_b
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.vpc.id
  v4_cidr_blocks = ["192.168.11.0/24"]
}

resource "yandex_vpc_subnet" "subnet-master2-a" {
  name           = local.subnet_name_master2_a
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.vpc.id
  v4_cidr_blocks = ["192.168.12.0/24"]
}

resource "yandex_vpc_subnet" "subnet-worker1-a" {
  name           = local.subnet_name_worker1_a
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.vpc.id
  v4_cidr_blocks = ["192.168.13.0/24"]
}

resource "yandex_vpc_subnet" "subnet-worker1-b" {
  name           = local.subnet_name_worker1_b
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.vpc.id
  v4_cidr_blocks = ["192.168.14.0/24"]
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