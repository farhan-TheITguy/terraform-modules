variable "name" {
  type = string
}
variable "instance_type" {
  type = string
}
variable "subnet_id" {
  type = string
}
variable "ami_name_filter" {
  type = string
}
variable "ami_owner" {
  type = string
}
variable "key_pair" {
  type = string
}
variable "generate_public_ip" {
  type = bool
  default = false
}
variable "root_vol_size" {
  type = number
  default = 20
}
variable "root_vol_type" {
  type = string
  default = "gp2"
}
variable "security_groups" {
  type = list(string)
  default = []
}
variable "playbook" {
  type = string
  default = ""
}
