
output "production-network.id" {
  value = "${aws_vpc.production-network.id}"
}

output "production-subnetwork-1.id" {
  value = "${aws_subnet.production-subnetwork-1.id}"
}

output "production-subnetwork-2.id" {
  value = "${aws_subnet.production-subnetwork-2.id}"
}

output "production-subnetwork-3.id" {
  value = "${aws_subnet.production-subnetwork-3.id}"
}

output "production-ssh-allowed.id" {
  value = "${aws_security_group.production-ssh-allowed.id}"
}