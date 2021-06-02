 variable "aws_profile" {
     type = string
     default = "ts-non-prod"
 }

 variable "env_name" {
     type = string
     default = "test-devops"
 }

 variable "aws_region" {
     type = string
     default = "us-east-1"
 }

 variable "source_repository" {
     type = string
     default = "chorus"
 }

variable "source_repository_url" {
     type = string
     default = "https://bitbucket.org/tolunaengineering/chorus.git"
 }

 variable "source_branch" {
     type = string
     default = "develop"
 }

