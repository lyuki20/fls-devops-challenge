terraform {
  backend "s3" {
    bucket = "lucatsutsumi-terraform-statefile"
    key    = "state.tfstate"
    region = "us-east-1"
  }
}

resource "aws_s3_bucket" "website" {
  bucket = "lucatsutsumi-bucket-website"

}

resource "aws_s3_bucket_website_configuration" "website_config" {
  bucket = aws_s3_bucket.website.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }

}

resource "aws_s3_bucket_public_access_block" "website_public_block" {
  bucket = aws_s3_bucket.website.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "website_policy_apply" {
  bucket = aws_s3_bucket.website.id
  policy = data.aws_iam_policy_document.website_policy.json
}

data "aws_iam_policy_document" "website_policy" {
  statement {
    sid = "PublicReadGetObject"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    actions = ["s3:GetObject"]


    resources = ["${aws_s3_bucket.website.arn}/*"]
  }
}