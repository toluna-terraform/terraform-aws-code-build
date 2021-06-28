 variable "env_name" {
     type     = string
 }

 variable "source_repository" {
     default = "chorus"
     type     = string

 }

variable "source_repository_url" {
    default  = "https://bitbucket.org/tolunaengineering/chorus.git"
    type     = string
 }

 variable "source_branch" {
     type     = string
     default = "master"
 }

 variable "buildspec_file" {
     type     = string
 }

variable "environment_variables" {
  default = {}  
  type        = map(string)
}

variable "environment_variables_parameter_store" {
  default = {} 
  type        = map(string)
}

variable "privileged_mode" { 
    type        = bool
    default     = true
    description = "set to true if building a docker"
}
