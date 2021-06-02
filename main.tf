locals{
    splited_repository_list= split("/",var.source_repository)
    repository_name = local.splited_repository_list[1]
    branch_name = var.source_branch
}


resource "aws_codebuild_project" "codebuild" {
  name          = "codebuild-${var.env_name}-${local.repository_name}" 
  description   = "Build spec for ${local.repository_name}"
  build_timeout = "120"
  service_role  = aws_iam_role.codebuild_role.arn

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
    type            = "GITHUB"
    location        = "https://github.com/toluna-terraform/terraform-aws-code-build.git"
    git_clone_depth = 1
    buildspec = file("files/buildspec.yml")

    # auth_type   = "PERSONAL_ACCESS_TOKEN"
    # server_type = "GITHUB"
    # token       = "example"

    git_submodules_config {
      fetch_submodules = false
    }

  }

    tags = tomap({
                Name="codebuild-${var.env_name}-${local.repository_name}",
                environment=var.env_name,
                created_by="terraform"
    })
}

resource "aws_iam_role" "codebuild_role" {
  name = "role-${local.repository_name}-${var.env_name}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "codebuild.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy" "cloudWatch_policy" {
  name = "test_policy"
  role = aws_iam_role.codebuild_role.id

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:PutLogEvents"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

provider "aws" {
    region = var.aws_region
    profile = var.aws_profile
}