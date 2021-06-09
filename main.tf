locals{
    repository_name = var.source_repository
    repository_url = var.source_repository_url
    branch_name = var.source_branch
    build_name = "codebuild-${var.env_name}-${local.repository_name}" 
}


resource "aws_codebuild_project" "codebuild" {
  name          = "${local.build_name}"
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

    dynamic "environment_variable" {
      for_each = var.environment_variables
      
      content {
        name                 = environment_variable.key
        value                = environment_variable.value
      }

    }
      dynamic "environment_variable" {
        for_each = var.environment_variables_parameter_store
        
        content {
          name                 = environment_variable.key
          value                = environment_variable.value
          type                 = "PARAMETER_STORE"
        }

      }

      privileged_mode = var.privileged_mode  
  }

  logs_config {
    cloudwatch_logs {
      group_name  = "/${var.env_name}/${local.build_name}/log-group"
      stream_name = "/${var.env_name}/${local.build_name}/stream"
    }
  }

  source {
    type            = "BITBUCKET"
    location        = local.repository_url
    git_clone_depth = 1
    buildspec = file(var.buildspec_file)

    git_submodules_config {
      fetch_submodules = false
    }
  }

   source_version =  local.branch_name

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
//this should be a variable - this one is specific to ecr
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
            "logs:PutLogEvents",
            "ecr:*",
            "ssm:*"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

provider "aws" {
    region = var.aws_region
   // profile = var.aws_profile
}