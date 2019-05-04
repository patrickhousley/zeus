data "aws_iam_policy_document" "s3_cloudfront_policy" {
  statement {
    actions = ["s3:GetObject"]
    resources = [
      "${aws_s3_bucket.www_patrickhousley_dev.arn}/*"
    ]

    principals {
      type = "AWS"
      identifiers = [
        "${aws_cloudfront_origin_access_identity.patrickhousley_dev_origin_access.iam_arn}"
      ]
    }
  }
  statement {
    actions = ["s3:ListBucket"]
    resources = [
      "${aws_s3_bucket.www_patrickhousley_dev.arn}"
    ]

    principals {
      type = "AWS"
      identifiers = [
        "${aws_cloudfront_origin_access_identity.patrickhousley_dev_origin_access.iam_arn}"
      ]
    }
  }
}

data "aws_iam_policy_document" "leeroy" {
  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeSubnets",
      "s3:PutObject",
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:GetBucketAcl",
      "s3:GetBucketLocation"
    ]
    resources = [
      "*"
    ]
  }
}

resource "aws_iam_role" "leeroy" {
  name = "leeroy"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "leeroy" {
  name = "leeroy"
  policy = "${data.aws_iam_policy_document.leeroy.json}"
}

resource "aws_iam_role_policy_attachment" "leeroy" {
  role = "${aws_iam_role.leeroy.name}"
  policy_arn = "${aws_iam_policy.leeroy.arn}"
}
