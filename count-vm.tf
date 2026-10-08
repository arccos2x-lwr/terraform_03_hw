# Создаем две одинаковые ВМ с именами web-1 и web-2
resource "yandex_compute_instance" "web" {
  count = 2
  name  = "web-${count.index + 1}" # count.index начинается с 0, поэтому +1
  hostname = "web-${count.index + 1}"
  platform_id = var.vm_storage_platform_id
  depends_on = [yandex_compute_instance.db]

  resources {
    cores         = var.vm_web_cores
    memory        = var.vm_web_memory
    core_fraction = var.vm_web_core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = var.vm_web_image_id
      size     = var.vm_web_disk_size
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