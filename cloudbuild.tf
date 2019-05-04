resource "aws_codebuild_project" "prometheus" {
  name = "prometheus"
  build_timeout = "5"
  service_role = "${aws_iam_role.leeroy.arn}"

  artifacts {
    type = "NO_ARTIFACTS"
  }

  cache {
    type = "S3"
    location = "${aws_s3_bucket.leeroy.bucket}/prometheus"
  }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image = "aws/codebuild/standard:1.0"
    type = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
  }

  source {
    type = "GITHUB"
    location = "https://github.com/patrickhousley/prometheus.git"
    git_clone_depth = 1
  }

  vpc_config {
    vpc_id = "${module.build_vpc.vpc_id}"
    subnets = ["${module.build_vpc.private_subnets}"]
    security_group_ids = ["${module.build_vpc.default_security_group_id}"]
  }
}
