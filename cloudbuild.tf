resource "aws_codebuild_project" "zeus" {
  name = "zeus"
  build_timeout = "5"
  service_role = "${aws_iam_role.leeroy.arn}"

  artifacts {
    type = "NO_ARTIFACTS"
  }

  cache {
    type = "S3"
    location = "${aws_s3_bucket.leeroy.bucket}"
  }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image = "aws/codebuild/standard:1.0"
    type = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
  }

  source {
    type = "GITHUB"
    location = "https://github.com/patrickhousley/zeus.git"
    git_clone_depth = 1
  }

  vpc_config {
    vpc_id = "${aws_default_vpc.default.id}"

    subnets = [
      "${aws_default_subnet.default_az1.id}"
    ]

    security_group_ids = [
      "${aws_default_vpc.default.default_security_group_id}"
    ]
  }

  tags = {
    "Environment" = "Test"
  }
}
