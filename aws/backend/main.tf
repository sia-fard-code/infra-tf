//This module is exclusively used to setup the backend to hold Terraform's state
provider "aws" {
  region     = var.region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

resource "aws_s3_bucket" "s3" {
  bucket        = var.s3_backend_bucket_name
  force_destroy = true
  acl           = "private"
  tags = {
    Name        = var.s3_backend_bucket_name
    Description = "Managed and used by Terraform"
  }
  versioning {
    enabled = true
  }
  # Enable server-side encryption by default
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "aws_s3_bucket_public_access_block" "s3-block-public-access" {
  bucket              = aws_s3_bucket.s3.id
  block_public_acls   = true
  block_public_policy = true
}

resource "aws_dynamodb_table" "terraform-state-lock-table" {
  name           = var.terraform_state_lock_table_name
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}
