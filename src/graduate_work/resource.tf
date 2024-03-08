resource "yandex_compute_image" "ubuntu_2004" {
  source_family = "ubuntu-2004-lts"
}

resource "yandex_compute_instance" "vm-master1-a" {
  name      = local.vm_master1_a_name
  hostname  = local.vm_master1_a_name
#  folder_id = yandex_resourcemanager_folder.folder-a.id
  zone      = local.zone_a

  boot_disk {
    initialize_params {
      image_id = yandex_compute_image.ubuntu_2004.id
      size = 20
    }
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-a.id
    nat       = true
  }
  resources {
    core_fraction = 100
    cores         = 2
    memory        = 4
  }
  metadata = {
    user-data = "${file("./meta.txt")}"
  }
}

resource "yandex_compute_instance" "vm-master1-b" {
  name      = local.vm_master1_b_name
#  folder_id = yandex_resourcemanager_folder.folder-b.id
  hostname  = local.vm_master1_b_name
  zone      = local.zone_b

  boot_disk {
    initialize_params {
      image_id = yandex_compute_image.ubuntu_2004.id
      size = 20
    }
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-b.id
    nat       = true
  }
  resources {
    core_fraction = 100
    cores         = 2
    memory        = 4
  }
  metadata = {
    user-data = "${file("./meta.txt")}"
  }
}

#resource "yandex_compute_instance" "vm-master2-a" {
#  name      = local.vm_master2_a_name
#  folder_id = yandex_resourcemanager_folder.folder-a.id
#  hostname  = local.vm_master2_a_name
#  zone      = local.zone_a
#
#  boot_disk {
#    initialize_params {
#      image_id = yandex_compute_image.ubuntu_2004.id
#      size = 20
#    }
#  }
#  network_interface {
#    subnet_id = yandex_vpc_subnet.subnet-a.id
#    nat       = true
#  }
#  resources {
#    core_fraction = 100
#    cores         = 2
#    memory        = 4
#  }
#  metadata = {
#    user-data = "${file("./meta.txt")}"
#  }
#}
#
#resource "yandex_compute_instance" "vm-worker1-a" {
#  name      = local.vm_worker1_a_name
#  folder_id = yandex_resourcemanager_folder.folder-a.id
#  hostname  = local.vm_worker1_a_name
#  zone      = local.zone_a
#
#  boot_disk {
#    initialize_params {
#      image_id = yandex_compute_image.ubuntu_2004.id
#      size = 20
#    }
#  }
#  network_interface {
#    subnet_id = yandex_vpc_subnet.subnet-a.id
#    nat       = true
#  }
#  resources {
#    core_fraction = 100
#    cores         = 2
#    memory        = 4
#  }
#  metadata = {
#    user-data = "${file("./meta.txt")}"
#  }
#}
#
#resource "yandex_compute_instance" "vm-worker1-b" {
#  name      = local.vm_worker1_b_name
#  folder_id = yandex_resourcemanager_folder.folder-b.id
#  hostname  = local.vm_worker1_b_name
#  zone      = local.zone_b
#
#  boot_disk {
#    initialize_params {
#      image_id = yandex_compute_image.ubuntu_2004.id
#      size = 20
#    }
#  }
#  network_interface {
#    subnet_id = yandex_vpc_subnet.subnet-b.id
#    nat       = true
#  }
#  resources {
#    core_fraction = 100
#    cores         = 2
#    memory        = 4
#  }
#  metadata = {
#    user-data = "${file("./meta.txt")}"
#  }
#}

# Outputs

output "vm-master1-a" {
  value = yandex_compute_instance.vm-master1-a.network_interface.0.nat_ip_address
}

output "vm-master1-b" {
  value = yandex_compute_instance.vm-master1-b.network_interface.0.nat_ip_address
}

#output "vm-master2-a" {
#  value = yandex_compute_instance.vm-master2-a.network_interface.0.nat_ip_address
#}
#
#output "vm-worker1-a" {
#  value = yandex_compute_instance.vm-worker1-a.network_interface.0.nat_ip_address
#}
#
#output "vm-worker1-b" {
#  value = yandex_compute_instance.vm-worker1-b.network_interface.0.nat_ip_address
#}