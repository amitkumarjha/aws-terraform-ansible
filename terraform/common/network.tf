#Create a network with a global range
resource "aws_vpc" "production-network" {
    cidr_block = "10.0.0.0/16"
    instance_tenancy = "default"
    tags {
        Name = "${var.network}"
    }
}

#create a subnetwork in each zone with 255 IP
resource "aws_subnet" "production-subnetwork-public" {
  cidr_block = "10.0.0.0/24"
  vpc_id = "${aws_vpc.production-network.id}"
  map_public_ip_on_launch = true
  availability_zone = "${var.zone1}"
  tags = {
        Name = "${var.subnet-1}"
  }
}

resource "aws_subnet" "production-subnetwork-private" {
  cidr_block = "10.0.1.0/24"
  vpc_id = "${aws_vpc.production-network.id}"
  availability_zone = "${var.zone2}"
  tags = {
        Name = "${var.subnet-2}"
  }
}

resource "aws_internet_gateway" "production-internet-gateway" {
  vpc_id = "${aws_vpc.production-network.id}"
  tags = {
        Name = "${var.internet-gateway}"
  }
}

resource "aws_eip" "prodcution-nat-gateway-eip" {
  vpc = true
  tags = {
        Name = "prodcution-nat-gateway-eip"
  }
}

resource "aws_nat_gateway" "prodcution-nat-gateway" {
  allocation_id = "${aws_eip.prodcution-nat-gateway-eip.id}"
  subnet_id = "${aws_subnet.production-subnetwork-public.id}"
  depends_on = ["aws_internet_gateway.production-internet-gateway"]
  tags = {
        Name = "prodcution-nat-gateway"
  }
}


resource "aws_security_group" "production-security-public" {
  vpc_id = "${aws_vpc.production-network.id}"
  name = "production-security-public"
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
    cidr_blocks = ["122.176.117.200/32"]
  }
  tags = {
        Name = "production-security-public"
  }
}

resource "aws_security_group" "production-security-private" {
  vpc_id = "${aws_vpc.production-network.id}"
  name = "production-security-private"
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
    cidr_blocks = ["10.0.0.0/24"]
  }
  ingress {
    from_port = 0
    protocol = -1
    to_port = 0
    cidr_blocks = ["10.0.1.0/24"]
  }
  tags = {
        Name = "production-security-private"
  }
}

resource "aws_route_table" "production-route-public" {
  vpc_id = "${aws_vpc.production-network.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.production-internet-gateway.id}"
  }
  tags = {
        Name = "production-route-public"
  }
}

resource "aws_route_table" "production-route-private" {
  vpc_id = "${aws_vpc.production-network.id}"
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.prodcution-nat-gateway.id}"
  }
  tags = {
        Name = "production-route-private"
  }
}

resource "aws_route_table_association" "production-route-association-public" {
  route_table_id = "${aws_route_table.production-route-public.id}"
  subnet_id = "${aws_subnet.production-subnetwork-public.id}"
}

resource "aws_route_table_association" "production-route-association-private" {
  route_table_id = "${aws_route_table.production-route-private.id}"
  subnet_id = "${aws_subnet.production-subnetwork-private.id}"
}