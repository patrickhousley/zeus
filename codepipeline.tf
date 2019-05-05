resource "aws_codepipeline" "prometheus" {
  name = "prometheus"
  role_arn = "${aws_iam_role.leeroy_pipeline.arn}"

  artifact_store {
    location = "${aws_s3_bucket.leeroy.bucket}"
    type = "S3"
  }

  stage {
    name = "Source"

    action {
      name = "Source"
      category = "Source"
      owner = "ThirdParty"
      provider = "GitHub"
      version = "1"
      output_artifacts = ["code"]

      configuration = {
        Owner = "patrickhousley"
        Repo = "prometheus"
        Branch = "master"
        OAuthToken = "${var.githubOAuthToken}"
      }
    }
  }

  stage {
    name = "Build"

    action {
      name = "Build"
      category = "Build"
      owner = "AWS"
      provider = "CodeBuild"
      input_artifacts = ["code"]
      output_artifacts = ["build"]
      version = "1"

      configuration = {
        ProjectName = "${aws_codebuild_project.prometheus.name}"
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name = "Deploy"
      category = "Deploy"
      owner = "AWS"
      provider = "S3"
      input_artifacts = ["build"]
      version = "1"

      configuration {
        BucketName = "${aws_s3_bucket.www_patrickhousley_dev.id}"
        Extract = "true"
      }
    }
  }
}
