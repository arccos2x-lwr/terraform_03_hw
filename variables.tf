###cloud vars
/*
variable "token" {
  type        = string
  description = "OAuth-token; https://cloud.yandex.ru/docs/iam/concepts/authorization/oauth-token"
}
*/

variable "cloud_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}
variable "default_cidr" {
  type        = list(string)
  default     = ["10.0.1.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "vpc_name" {
  type        = string
  default     = "develop"
  description = "VPC network&subnet name"
}

# --- Переменные для ВМ ---

variable "vm_web_image_id" {
  type        = string
  default     = "fd827b91d99psvq5fjit"
}

variable "vm_web_cores" {
  type        = number
  default     = 2
}

variable "vm_web_memory" {
  type        = number
  default     = 1
}

variable "vm_web_core_fraction" {
  type        = number
  default     = 20
}

variable "vm_web_disk_size" {
  type        = number
  default     = 10
}

variable "vm_db_image_id" {
  type        = string
  default     = "fd827b91d99psvq5fjit"
}

variable "vm_storage_cores" {
  type        = number
  default     = 2
}

variable "vm_storage_memory" {
  type        = number
  default     = 2
}

variable "vm_storage_disk_size" {
  type        = number
  default     = 10
}

variable "vm_storage_platform_id" {
  type        = string
  default     = "standard-v1"
}

variable "vm_storage_image_id" {
  type        = string
  default     = "fd827b91d99psvq5fjit"
}

variable "vm_preemptible" {
  type        = bool
  default     = true
}

variable "vm_platform_id" {
  type        = string
  default     = "standard-v1"
}

# Локальная переменная для чтения публичного ключа SSH
locals {
  ssh_key = file("~/.ssh/id_ed25519.pub")
}