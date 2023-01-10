resource "yandex_compute_instance" "vm1-ubuntu" {
  count                 = local.count[terraform.workspace]
  name                  = "Ubuntu_server_${count.index + 1}_${terraform.workspace}"
  lifecycle {
    create_before_destroy = true
  }
  boot_disk {
    initialize_params {
      image_id = local.image_id[terraform.workspace]
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
    user-data = file("./meta.txt")
  }
}

resource "yandex_compute_instance" "vm2-ubuntu" {
  for_each = toset( terraform.workspace == "prod" ? ["One", "Two"] : ["One"])

  name = "Ubuntu_server_${each.key}_${terraform.workspace}"

  boot_disk {
    initialize_params {
      image_id = local.image_id[terraform.workspace]
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
    user-data = file("./meta.txt")
  }
}