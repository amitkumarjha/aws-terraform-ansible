terraform {
  backend "s3" {
    bucket = "terraform-test-production"
    key  = "elasticsearch/terraform.tfstate"
    region = "ap-south-1"
  }
}