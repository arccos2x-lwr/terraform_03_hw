# Три одинаковых диска по 1 Гб
resource "yandex_compute_disk" "extra" {
  count = 3
  name  = "extra-disk-${count.index + 1}"
  size  = 1
  zone  = var.default_zone
}

# Машина storage с динамическим подключением дисков
resource "yandex_compute_instance" "storage" {
  name = "storage"
  hostname = "storage"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd827b91d99psvq5fjit"
      size     = 10
    }
  }

  dynamic "secondary_disk" {
    for_each = yandex_compute_disk.extra
    content {
      disk_id = secondary_disk.value.id
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