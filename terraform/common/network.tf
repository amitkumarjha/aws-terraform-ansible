#Create a network with a global range
resource "aws_vpc" "production-network" {
    cidr_block = "10.1.0.0/16"
    instance_tenancy = "default"
    tags {
        Name = "${var.network}"
    }
}

#create a subnetwork in each zone with 255 IP
resource "aws_subnet" "production-subnetwork-1" {
  cidr_block = "10.1.1.0/24"
  vpc_id = "${aws_vpc.production-network.id}"
  availability_zone = "${var.zone1}"
  tags = {
        Name = "${var.subnet-1}"
  }
}

resource "aws_subnet" "production-subnetwork-2" {
  cidr_block = "10.1.2.0/24"
  vpc_id = "${aws_vpc.production-network.id}"
  availability_zone = "${var.zone2}"
  tags = {
        Name = "${var.subnet-2}"
  }
}

resource "aws_subnet" "production-subnetwork-3" {
  cidr_block = "10.1.3.0/24"
  vpc_id = "${aws_vpc.production-network.id}"
  availability_zone = "${var.zone3}"
  tags = {
        Name = "${var.subnet-3}"
  }
}

resource "aws_internet_gateway" "production-internet-gateway" {
  vpc_id = "${aws_vpc.production-network.id}"
  tags = {
        Name = "${var.internet-gateway}"
  }
}

resource "aws_security_group" "production-ssh-allowed" {
  vpc_id = "${aws_vpc.production-network.id}"
  name = "production-ssh-allowed"
  egress {
    from_port = 0
    protocol = -1
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 22
    protocol = "tcp"
    to_port = 22
    cidr_blocks = "${var.allowedsship}"
  }
  tags = {
        Name = "production-ssh-allowed"
  }
}

resource "aws_route_table" "production-route" {
  vpc_id = "${aws_vpc.production-network.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.production-internet-gateway.id}"
  }
  tags = {
        Name = "production-route"
  }
}

resource "aws_route_table_association" "production-route-subnet-1" {
  route_table_id = "${aws_route_table.production-route.id}"
  subnet_id = "${aws_subnet.production-subnetwork-1.id}"
}

resource "aws_route_table_association" "production-route-subnet-2" {
  route_table_id = "${aws_route_table.production-route.id}"
  subnet_id = "${aws_subnet.production-subnetwork-2.id}"
}

resource "aws_route_table_association" "production-route-subnet-3" {
  route_table_id = "${aws_route_table.production-route.id}"
  subnet_id = "${aws_subnet.production-subnetwork-3.id}"
}