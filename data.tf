data "aws_ami" "ubuntu_ami" {
  most_recent = true
  owners = ["099720109477"] # Canonical
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }
  filter {
      name   = "architecture"
      values = ["x86_64"]
  }
  filter {
      name   = "virtualization-type"
      values = ["hvm"]
  }
}


data "http" "my_ip" {
  url = "https://api.ipify.org?format=txt"
}
