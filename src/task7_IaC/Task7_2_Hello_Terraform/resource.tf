resource "yandex_compute_instance" "vm1-ubuntu" {
  boot_disk {
    initialize_params {
      image_id = "fd8bfmkt64o90eu4pksv"
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
    user-data = "${file("./meta.txt")}"
  }
}