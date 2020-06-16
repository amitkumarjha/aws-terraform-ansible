terraform {
  backend "s3" {
    bucket = "terraform-test-production"
    key  = "common/terraform.tfstate"
    region = "ap-south-1"
  }
}