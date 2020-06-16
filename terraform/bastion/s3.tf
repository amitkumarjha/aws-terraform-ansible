terraform {
  backend "s3" {
    bucket = "terraform-test-production"
    key  = "bastion/terraform.tfstate"
    region = "ap-south-1"
  }
}