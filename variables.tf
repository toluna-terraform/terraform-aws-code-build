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
 variable "name" {
     type = string
     default = ""
 }
 variable "env_type" {
     type = string
     default = "non-prod"
 }
 variable "source_repository" {
     type = string
     default = "tolunaengineering/chorus"
 }
 variable "source_branch" {
     type = string
     default = "master"
 }

