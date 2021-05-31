locals{
    splited_repository_list= split("/",var.source_repository)
    repository_name = splited_repository_list[length(splited_repository_list)]
    splited_branch_list = split("/", var.source_branch)
    branch_name = splited_branch_list[length(splited_branch_list)]
}


module "aws_codebuild_project" {

}

resource "aws_codebuild_project" "codebuild" {
  name          = "build-${local.repository_name}-${local.branch_name}" 
  description   = "Build spec for ${local.repository_name}"
  build_timeout = "500"
  service_role  = aws_iam_role.codebuild_role

  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:3.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
  }

  logs_config {
    cloudwatch_logs {
      group_name  = "log-group"
      stream_name = "log-stream"
    }
  }

  source {
    type            = "BITBUCKET"
    location        = "https://github.com/mitchellh/packer.git"
    git_clone_depth = 1

    git_submodules_config {
      fetch_submodules = false
    }
  }

  source_version = var.source_branch

    tags = tomap({
                Name="codebuild-${locals.prefix}",
                environment=var.env_name,
                created_by="terraform"
    })
}

resource "aws_iam_role" "codebuild_role" {
  name = "role-${local.repository_name}-${var.env_name}"

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

provider "aws" {
    region = var.aws_region
    profile = var.aws_profile
}