 variable "aws_profile" {
     type = string
 }

 variable "env_name" {
     type = string
 }

 variable "aws_region" {
     type = string
     default = "us-east-1"
 }

 variable "source_repository" {
     type = string
 }

variable "source_repository_url" {
     type = string
 }

 variable "source_branch" {
     type = string
     default = "develop"
 }

