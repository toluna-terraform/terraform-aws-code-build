 variable "env_name" {
     type     = string
 }

 variable "aws_region" {
     type     = string
     default  = "us-east-1"
 }

 variable "source_repository" {
     type     = string
 }

variable "source_repository_url" {
     type     = string
 }

 variable "source_branch" {
     type     = string
 }

 variable "buildspec_file" {
     type     = string
 }

variable "environment_variables" {
  type        = map(string)
}

variable "environment_variables_parameter_store" {
  type        = map(string)
}

variable "privileged_mode" { 
    type        = bool
    default     = true
    description = "set to true if building a docker"
}