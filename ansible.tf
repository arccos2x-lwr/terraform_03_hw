# ------------------------------------------------------------------
# Собираем данные со всех ВМ в единый список объектов.
# Используем функции из демонстрации: concat, flatten, try.
# ------------------------------------------------------------------

locals {
  # ВМ веб-серверов (созданы через count в count-vm.tf)
  webservers_raw = [
    for vm in yandex_compute_instance.web : {
      name = vm.name
      ip   = try(vm.network_interface[0].nat_ip_address, "0.0.0.0")
      fqdn = try(vm.fqdn, "${vm.name}.ru-central1.internal")
    }
  ]

  # ВМ баз данных (созданы через for_each в for_each-vm.tf)
  databases_raw = [
    for vm in yandex_compute_instance.db : {
      name = vm.name
      ip   = try(vm.network_interface[0].nat_ip_address, "0.0.0.0")
      fqdn = try(vm.fqdn, "${vm.name}.ru-central1.internal")
    }
  ]

  # ВМ storage (создана как одиночный ресурс в disk_vm.tf)
  storage_raw = [
    for vm in [yandex_compute_instance.storage] : {
      name = vm.name
      ip   = try(vm.network_interface[0].nat_ip_address, "0.0.0.0")
      fqdn = try(vm.fqdn, "${vm.name}.ru-central1.internal")
    }
  ]

  # Общий список всех ВМ (аналог flatten + concat из демонстрации)
  all_vms = flatten(concat(
    local.webservers_raw,
    local.databases_raw,
    local.storage_raw,
  ))

  # Сводная карта name -> данные (аналог merge из демонстрации)
  all_vms_map = {
    for vm in local.all_vms : vm.name => vm
  }
}

# ------------------------------------------------------------------
# Генерируем inventory-файл для Ansible через templatefile.
# ------------------------------------------------------------------
resource "local_file" "ansible_inventory" {
  content = templatefile("${path.module}/inventory.tmpl", {
    webservers = local.webservers_raw
    databases  = local.databases_raw
    storage    = local.storage_raw
  })

  filename = "${path.module}/inventory.ini"

  # Перегенерируем файл, если хоть одна ВМ изменилась
  depends_on = [
    yandex_compute_instance.web,
    yandex_compute_instance.db,
    yandex_compute_instance.storage,
  ]
}