variable "aws_access_key" {}

variable "aws_secret_key" {}

variable "private_key_path" {}

variable "key_name" {}

variable "region" {}

variable "vpc_id" {}

variable "subnet_id" {}

variable "count" {
  default = 1
}

variable "ws_count" {
  default = 1
}

variable "awx_cert_arn" {}

variable  "zone_name" {}
