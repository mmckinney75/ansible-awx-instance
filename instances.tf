resource "aws_instance" "ansible-awx-ubuntu" {

  count = "${var.count}"

  instance_type           = "t2.medium"
  ami                     = "${data.aws_ami.ubuntu_ami.id}"
  key_name                = "${var.key_name}"
  vpc_security_group_ids  = ["${aws_security_group.ansible_awx_sg.id}"]
  subnet_id               = "${var.subnet_id}"
  tags {
    Name = "ansible-awx-${(count.index+1)}"
  }

  connection {
    user = "ubuntu"
    private_key = "${file(var.private_key_path)}"
  }

  provisioner "file" {
    source      = "scripts/install_ansible_awx.sh"
    destination = "/home/ubuntu/install_ansible_awx.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod 744 /home/ubuntu/install_ansible_awx.sh",
      "/home/ubuntu/install_ansible_awx.sh",
    ]
  }

  provisioner "file" {
    content     = "${data.template_file.awx_id_rsa_pub.rendered}"
    destination = "/home/ubuntu/.ssh/id_rsa.pub"
  }

  provisioner "file" {
    content     = "${data.template_file.awx_id_rsa.rendered}"
    destination = "/home/ubuntu/.ssh/id_rsa"
  }

}

resource "aws_instance" "default-web-ubuntu" {

  count = "${var.ws_count}"

  instance_type           = "t2.micro"
  ami                     = "${data.aws_ami.ubuntu_ami.id}"
  key_name                = "${var.key_name}"
  vpc_security_group_ids  = ["${aws_security_group.ansible_managed_sg.id}","${aws_security_group.default_web_sg.id}"]
  subnet_id               = "${var.subnet_id}"
  tags {
    Name = "default-ws-${(count.index+1)}"
  }

  connection {
    user = "ubuntu"
    private_key = "${file(var.private_key_path)}"
  }

  provisioner "remote-exec" {
    inline = [
      "echo '${data.template_file.awx_id_rsa_pub.rendered}' >> /home/ubuntu/.ssh/authorized_keys",
    ]
  }

}
