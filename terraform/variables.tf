variable "region" {
  default = "ap-south-1"
}

variable "zone1" {
  default = "ap-south-1a"
}

variable "zone2" {
  default = "ap-south-1b"
}

variable "zone3" {
  default = "ap-south-1c"
}

variable "network" {
  default = "production-network"
}

variable "subnet-1" {
  default = "production-subnetwork-public"
}

variable "subnet-2" {
  default = "production-subnetwork-private"
}


variable "internet-gateway" {
  default = "production-internet-gateway"
}

variable "ami-ubuntu-18" {
  default = "ami-0b44050b2d893d5f7"
}

variable "instance-type" {
  default = "t2.micro"
}

variable "allowedsship" {
  default = ["122.176.117.200/32",
              "10.1.0.0/16"]
}

variable "ec2-user" {
  default = "terraform"
}

variable "private-key-path" {
  default = "bastion_public_key"
}

variable "public-key-path" {
  default = "bastion_public_key.pub"
}

variable "aws-key-name" {
  default = "bastion_public_key"
}
