resource "yandex_compute_instance" "clickhouse-01" {
  boot_disk {
    initialize_params {
      image_id = yandex_compute_image.centos-7.id
    }
  }
  network_interface {
    subnet_id = "e9bibsvqqoqfrf7ef0vo"
    nat       = true
  }
  resources {
    cores  = 4
    memory = 4
  }
  metadata = {
    ssh-keys = "slava:${file("~/.ssh/yac2.pub")}"
  }
}

resource "yandex_compute_instance" "vector-01" {
  boot_disk {
    initialize_params {
      image_id = yandex_compute_image.centos-7.id
    }
  }
  network_interface {
    subnet_id = "e9bibsvqqoqfrf7ef0vo"
    nat       = true
  }
  resources {
    cores  = 2
    memory = 2
  }
  metadata = {
    ssh-keys = "slava:${file("~/.ssh/yac2.pub")}"
  }
}

resource "yandex_compute_instance" "lighthouse-01" {
  boot_disk {
    initialize_params {
      image_id = yandex_compute_image.centos-7.id
    }
  }
  network_interface {
    subnet_id = "e9bibsvqqoqfrf7ef0vo"
    nat       = true
  }
  resources {
    cores  = 2
    memory = 2
  }
  metadata = {
    ssh-keys = "slava:${file("~/.ssh/yac2.pub")}"
  }
}