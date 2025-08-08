# provider "aws" {
#   region = "us-east-1"
#   profile = var.profile
# }

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

resource "random_id" "random" {
  byte_length = 8
}

resource "aws_s3_bucket" "s3_bucket" {
  bucket = "my-bucket-tf-unique"
  force_destroy = true 
   tags = {
    Name="my-bucket"
    Environment= "Dev"
   }
}

resource "aws_s3_object" "test_upload_bucket" {
  for_each = fileset(var.path,"**")
  bucket = aws_s3_bucket.s3_bucket.id
  key = each.key
  source = "${var.path}/${each.value}"
  etag = filemd5("${var.path}/${each.value}")
  server_side_encryption = "AES256"
  tags = {
    Name ="My Bucket"
    Environment = "Dev"
  }
}

resource "aws_kms_key" "s3_bucket_kms_key" {
  description = "kms s3 bucket"
  deletion_window_in_days = 2
  tags = {
    Name = "KMS key for s3 bucket"
  }
}

resource "aws_kms_alias" "s3_alias_aws" {
  name = "alias/s3_bucket_kms_key_alias"
  target_key_id = aws_kms_key.s3_bucket_kms_key.key_id
}

resource "aws_s3_bucket_server_side_encryption_configuration" "s3_bucket_encryption_with_kms_key" {
  bucket = aws_s3_bucket.s3_bucket.id
  rule {
    apply_server_side_encryption_by_default {
        kms_master_key_id =  aws_kms_key.s3_bucket_kms_key.arn
        sse_algorithm = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "public_access_block" {
  bucket = aws_s3_bucket.s3_bucket.id

  block_public_policy = false
  block_public_acls = false
  ignore_public_acls = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "policy_bucket" {
   bucket = aws_s3_bucket.s3_bucket.id
   policy = jsonencode({
    Version: "2012-10-17",
    Statement:[{
      Effect: "Allow"
      Principal: "*"
      Action:"s3:GetObject"
      Resource: "${aws_s3_bucket.s3_bucket.arn}/*"
    }]
   })

   depends_on = [aws_s3_bucket_public_access_block.public_access_block]
}


//Bucket versioning
resource "aws_s3_bucket_versioning" "bucket_versioning" {
  bucket = aws_s3_bucket.s3_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "s3_bucket_lifecycle" {
  bucket = aws_s3_bucket.s3_bucket.id
  
  rule {
    id = "config"

    filter {
      prefix = "/"
    }

    noncurrent_version_expiration {
      noncurrent_days = 90
    }

   noncurrent_version_transition {
      noncurrent_days = 60
      storage_class = "GLACIER"
    }

    noncurrent_version_transition {
      noncurrent_days = 30
      storage_class = "STANDARD_IA"
    }

    status = "Enabled"
  }
}


//Logging bucket
resource "aws_s3_bucket" "log_bucket" {
  bucket = format("%s-%s", "my-demo-test",random_id.random.hex)
  tags = {
    Name = "log bucket"
    Environment = "Dev"
  }
}


resource "aws_s3_bucket_logging" "s3_bucket_logging" {
    bucket = aws_s3_bucket.s3_bucket.id

    target_bucket = aws_s3_bucket.log_bucket.id
    target_prefix = "log/"
}

// object loking
resource "aws_s3_bucket_object_lock_configuration" "lock_object" {
  bucket = aws_s3_bucket.s3_bucket.id
  rule {
    default_retention {
      mode = "COMPLIANCE"
      days = 1
    }
  }
}