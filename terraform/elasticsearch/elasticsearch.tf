resource "aws_instance" "elastic-node-1" {
  ami = "${var.ami-ubuntu-18}"
  instance_type = "${var.instance-type}"
  associate_public_ip_address = false
  subnet_id = "${data.terraform_remote_state.common.production-subnetwork-private.id}"
  vpc_security_group_ids = ["${data.terraform_remote_state.common.production-security-private.id}"]
  connection {
        user = "${var.ec2-user}"
  }
  key_name = "${var.aws-key-name}"
  tags = {
        Name = "elastic-node-1",
        Group = "elastic-node"
        e_type = "elastic_master"
  }
}

resource "aws_instance" "elastic-node-2" {
  ami = "${var.ami-ubuntu-18}"
  instance_type = "${var.instance-type}"
  associate_public_ip_address = false
  subnet_id = "${data.terraform_remote_state.common.production-subnetwork-private.id}"
  vpc_security_group_ids = ["${data.terraform_remote_state.common.production-security-private.id}"]
  connection {
        user = "${var.ec2-user}"
  }
  key_name = "${var.aws-key-name}"
  tags = {
        Name = "elastic-node-2",
        Group = "elastic-node"
        e_type = "elastic_nodes"
  }
}

resource "aws_instance" "elastic-node-3" {
  ami = "${var.ami-ubuntu-18}"
  instance_type = "${var.instance-type}"
  associate_public_ip_address = false
  subnet_id = "${data.terraform_remote_state.common.production-subnetwork-private.id}"
  vpc_security_group_ids = ["${data.terraform_remote_state.common.production-security-private.id}"]
  connection {
        user = "${var.ec2-user}"
  }
  key_name = "${var.aws-key-name}"
  tags = {
        Name = "elastic-node-3"
        Group = "elastic-node"
        e_type = "elastic_nodes"
  }
}