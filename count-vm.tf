# Создаем две одинаковые ВМ с именами web-1 и web-2
resource "yandex_compute_instance" "web" {
  count = 2
  name  = "web-${count.index + 1}" # count.index начинается с 0, поэтому +1
  hostname = "web-${count.index + 1}"
  depends_on = [yandex_compute_instance.db]

  resources {
    cores  = 2
    memory = 1
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = "fd827b91d99psvq5fjit" # Ubuntu 22.04 LTS (актуальный ID можно получить командой yc compute image list --folder-id standard-images)
      size     = 10
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.develop.id
    security_group_ids = [yandex_vpc_security_group.example.id]
    nat                = true
  }

  metadata = {
    ssh-keys = "ubuntu:${local.ssh_key}"
  }
}

# Локальная переменная для чтения публичного ключа SSH
locals {
  ssh_key = file("~/.ssh/id_ed25519.pub")
}