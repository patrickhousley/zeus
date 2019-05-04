provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket = "zeus.patrickhousley.dev"
    region = "us-east-1"
  }
}
