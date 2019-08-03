terraform {
  backend "s3" {
    bucket = "mmckinney-tfstate"
    key    = "ansible/awx"
    region = "us-east-1"
  }
}
