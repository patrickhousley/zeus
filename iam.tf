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
      "logs:PutLogEvents"
    ]
    resources = ["*"]
  }
  statement {
    actions = [
      "ec2:CreateNetworkInterface",
      "ec2:DescribeDhcpOptions",
      "ec2:DescribeNetworkInterfaces",
      "ec2:DeleteNetworkInterface",
      "ec2:DescribeSubnets",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeVpcs"
    ]
    resources = ["*"]
  }
  statement {
    actions = [
      "s3:*"
    ]
    resources = [
      "${aws_s3_bucket.leeroy.arn}",
      "${aws_s3_bucket.leeroy.arn}/*",
      "${aws_s3_bucket.www_patrickhousley_dev.arn}",
      "${aws_s3_bucket.www_patrickhousley_dev.arn}/*",
    ]
  }
  statement {
    actions = [
      "ec2:CreateNetworkInterfacePermission"
    ]
    resources = [
      "arn:aws:ec2:us-east-1:417919778916:network-interface/*"
    ]
    condition {
      test = "StringEquals"
      variable = "ec2:AuthorizedService"
      values = ["codebuild.amazonaws.com"]
    }
  }
  statement {
    actions = [
      "codebuild:BatchGetBuilds",
      "codebuild:StartBuild"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_role" "leeroy_pipeline" {
  name = "leeroy_pipeline"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codepipeline.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role" "leeroy_build" {
  name = "leeroy_build"
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

resource "aws_iam_role_policy_attachment" "leeroy_pipeline" {
  role = "${aws_iam_role.leeroy_pipeline.name}"
  policy_arn = "${aws_iam_policy.leeroy.arn}"
}

resource "aws_iam_role_policy_attachment" "leeroy_build" {
  role = "${aws_iam_role.leeroy_build.name}"
  policy_arn = "${aws_iam_policy.leeroy.arn}"
}
