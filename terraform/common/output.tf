
output "production-network.id" {
  value = "${aws_vpc.production-network.id}"
}

output "production-subnetwork-public.id" {
  value = "${aws_subnet.production-subnetwork-public.id}"
}

output "production-subnetwork-private.id" {
  value = "${aws_subnet.production-subnetwork-private.id}"
}

output "production-security-public.id" {
  value = "${aws_security_group.production-security-public.id}"
}

output "production-security-private.id" {
  value = "${aws_security_group.production-security-private.id}"
}