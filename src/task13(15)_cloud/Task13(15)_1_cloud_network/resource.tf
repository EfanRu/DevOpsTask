resource "yandex_compute_image" "ubuntu_2004" {
  source_family = "ubuntu-2004-lts"
}

resource "yandex_compute_instance" "vm-public" {
  name = local.vm_public_name

  boot_disk {
    initialize_params {
      image_id = yandex_compute_image.ubuntu_2004.id
    }
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.public.id
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

resource "yandex_compute_instance" "vm-private" {
  name = local.vm_private_name

  boot_disk {
    initialize_params {
      image_id = yandex_compute_image.ubuntu_2004.id
    }
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.private.id
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