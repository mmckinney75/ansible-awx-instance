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


data "aws_route53_zone" "dns_zone" {
  name = "${var.zone_name}"
}

data "http" "my_ip" {
  url = "https://api.ipify.org?format=txt"
}


data "template_file" "awx_id_rsa_pub" {
    template = "${file("templates/id_rsa.pub.tpl")}"
    vars {
        awx_key_pub_openssh = "${tls_private_key.awx_key.public_key_openssh}"
    }
}

data "template_file" "awx_id_rsa" {
    template = "${file("templates/id_rsa.tpl")}"
    vars {
        awx_key_priv_pem = "${tls_private_key.awx_key.private_key_pem}"
    }
}

data "aws_subnet_ids" "subnets_pub" {
  vpc_id = "${var.vpc_id}"
  filter {
    name   = "mapPublicIpOnLaunch"
    values = ["true"]       
  }
}

data "template_file" "awx_install_script" {
    template = "${file("templates/install_ansible_awx.sh.tpl")}"
    vars {
        awx_id_rsa = "${data.template_file.awx_id_rsa.rendered}"
    }
}
