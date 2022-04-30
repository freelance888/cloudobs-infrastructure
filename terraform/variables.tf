variable "instances_count" {
  description = "The amount of instances you need"
  default     = "3"
}

variable "instance_type" {
  description = "Hetzner Cloud instance type"
  default     = "cpx41"
}

variable "image" {
  description = "Hetzner Cloud system image"
  default     = "ubuntu-20.04"
}

variable "location" {
  description = "Hetzner Cloud instance type"
  default     = "hel1"
}
