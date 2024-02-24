resource "yandex_compute_image" "ubuntu_2004" {
  source_family = "ubuntu-2004-lts"
}

resource "yandex_compute_instance" "vm-master1-a" {
  name = local.vm_master1_a_name

  boot_disk {
    initialize_params {
      image_id = yandex_compute_image.ubuntu_2004.id
    }
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-master1-a.id
    nat       = true
  }
  resources {
    core_fraction = 5
    cores         = 2
    memory        = 2
  }
  metadata = {
    user-data = "${file("./meta.txt")}"
  }
}

resource "yandex_compute_instance" "vm-master1-b" {
  name = local.vm_master1_b_name

  boot_disk {
    initialize_params {
      image_id = yandex_compute_image.ubuntu_2004.id
    }
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-master1-b.id
    nat       = true
  }
  resources {
    core_fraction = 5
    cores         = 2
    memory        = 2
  }
  metadata = {
    user-data = "${file("./meta.txt")}"
  }
}

resource "yandex_compute_instance" "vm-master2-a" {
  name = local.vm_master2_a_name

  boot_disk {
    initialize_params {
      image_id = yandex_compute_image.ubuntu_2004.id
    }
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-master2-a.id
    nat       = true
  }
  resources {
    core_fraction = 5
    cores         = 2
    memory        = 2
  }
  metadata = {
    user-data = "${file("./meta.txt")}"
  }
}

resource "yandex_compute_instance" "vm-worker1-a" {
  name = local.vm_worker1_a_name

  boot_disk {
    initialize_params {
      image_id = yandex_compute_image.ubuntu_2004.id
    }
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-worker1-a.id
    nat       = true
  }
  resources {
    core_fraction = 5
    cores         = 2
    memory        = 2
  }
  metadata = {
    user-data = "${file("./meta.txt")}"
  }
}

resource "yandex_compute_instance" "vm-worker1-b" {
  name = local.vm_worker1_b_name

  boot_disk {
    initialize_params {
      image_id = yandex_compute_image.ubuntu_2004.id
    }
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-worker1-b.id
    nat       = true
  }
  resources {
    core_fraction = 5
    cores         = 2
    memory        = 2
  }
  metadata = {
    user-data = "${file("./meta.txt")}"
  }
}