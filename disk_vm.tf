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
    cores  = var.vm_storage_cores
    memory = var.vm_storage_memory
  }

  boot_disk {
    initialize_params {
      image_id = var.vm_storage_image_id
      size     = var.vm_storage_disk_size
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

  scheduling_policy {
    preemptible = var.vm_preemptible
  }

  metadata = {
    ssh-keys = "ubuntu:${local.ssh_key}"
  }
}