module "ubuntu1" {
  count = count[terraform.workspace]

  source  = "glavk/compute/yandex"
  version = "0.1.13"

  create_before_destroy = true

  image_family = "ubuntu-2004-lts"
  subnet       = "default"
  folder_id    = "ar.YC_FOLDER_ID"

  image_id = image_id[terraform.workspace]

  name     = "Ubuntu_server_${count.index + 1}_${terraform.workspace}"
  hostname = "vm${count.index + 1}_${terraform.workspace}-ubuntu"
  nat      = true

  cores  = 2
  memory = 2

  metadata = {
    user-data = file("./meta.txt")
  }

  sg_id = ["xxx"]
}

module "ubuntu2" {
  for_each = toset( terraform.workspace == "prod" ? ["One", "Two"] : ["One"])

  source  = "glavk/compute/yandex"
  version = "0.1.13"

  image_family = "ubuntu-2004-lts"
  subnet       = "default"
  folder_id    = "ar.YC_FOLDER_ID"

  name     = "Ubuntu_server_${each.key}_${terraform.workspace}"
  hostname = "vm${count.index + 1}_${terraform.workspace}-ubuntu"
  nat      = true

  cores  = 2
  memory = 2

  image_id = image_id[terraform.workspace]

  metadata = {
    user-data = file("./meta.txt")
  }

  sg_id = ["xxx"]
}
