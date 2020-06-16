data "terraform_remote_state" "common" {
  backend = "s3"

  config {
    bucket = "terraform-test-production"
    key  = "common/terraform.tfstate"
    region = "ap-south-1"
  }
}