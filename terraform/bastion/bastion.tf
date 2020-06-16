resource "aws_eip" "bastion_public_ip" {
  vpc = true
  instance = "${aws_instance.production-network-bastion.id}"
  tags = {
        Name = "bastion_public_ip"
  }
}

resource "aws_instance" "production-network-bastion" {
  ami = "${var.ami-ubuntu-18}"
  instance_type = "${var.instance-type}"
  associate_public_ip_address = true
  subnet_id = "${data.terraform_remote_state.common.production-subnetwork-1.id}"
  vpc_security_group_ids = ["${data.terraform_remote_state.common.production-ssh-allowed.id}"]
  connection {
        user = "${var.ec2-user}"
        private_key = "${file("${var.private-key-path}")}"
  }
  key_name = "${aws_key_pair.bastion_public_key.id}"
  tags = {
        Name = "production-network-bastion"
  }
}

resource "aws_key_pair" "bastion_public_key" {
  key_name = "${var.aws-key-name}"
  public_key = "${file(var.public-key-path)}"
  tags = {
        Name = "bastion_public_key"
  }
}