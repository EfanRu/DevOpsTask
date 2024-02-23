resource "yandex_compute_image" "ubuntu_2004" {
  source_family = "ubuntu-2004-lts"
}

resource "yandex_compute_instance" "vm-master-a" {
  name = local.vm_master_a_name

  boot_disk {
    initialize_params {
      image_id = yandex_compute_image.ubuntu_2004.id
    }
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.public-a.id
    nat       = true
  }
  resources {
    cores  = 2
    memory = 2
  }
  metadata = {
    user-data = "${file("./meta.txt")}"
  }
}

resource "yandex_compute_instance" "vm-master-b" {
  name = local.vm_master_b_name

  boot_disk {
    initialize_params {
      image_id = yandex_compute_image.ubuntu_2004.id
    }
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.public-b.id
    nat       = true
  }
  resources {
    cores  = 2
    memory = 2
  }
  metadata = {
    user-data = "${file("./meta.txt")}"
  }
}

resource "yandex_compute_instance" "vm-master-c" {
  name = local.vm_master_c_name

  boot_disk {
    initialize_params {
      image_id = yandex_compute_image.ubuntu_2004.id
    }
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.public-a.id
    nat       = true
  }
  resources {
    cores  = 2
    memory = 2
  }
  metadata = {
    user-data = "${file("./meta.txt")}"
  }
}

resource "yandex_compute_instance" "vm-worker-a" {
  name = local.vm_worker_a_name

  boot_disk {
    initialize_params {
      image_id = yandex_compute_image.ubuntu_2004.id
    }
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.public-a.id
    nat       = true
  }
  resources {
    cores  = 2
    memory = 2
  }
  metadata = {
    user-data = "${file("./meta.txt")}"
  }
}

resource "yandex_compute_instance" "vm-worker-b" {
  name = local.vm_worker_b_name

  boot_disk {
    initialize_params {
      image_id = yandex_compute_image.ubuntu_2004.id
    }
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.public-b.id
    nat       = true
  }
  resources {
    cores  = 2
    memory = 2
  }
  metadata = {
    user-data = "${file("./meta.txt")}"
  }
}