resource "aws_s3_bucket" "zeus" {
  # Main bucket for terraform state
  bucket = "zeus.patrickhousley.dev"
  acl = "private"
}

resource "aws_s3_bucket" "www_patrickhousley_dev" {
  # Main bucket for patrickhousley.dev static site
  bucket = "www.patrickhousley.dev"
  acl = "private"
}

resource "aws_s3_bucket_policy" "www_patrickhousley_dev_policy" {
  bucket = "${aws_s3_bucket.www_patrickhousley_dev.id}"
  policy = "${data.aws_iam_policy_document.s3_cloudfront_policy.json}"
}

resource "aws_s3_bucket" "leeroy" {
  bucket = "leeroy.patrickhousley.dev"
  acl = "private"
}
