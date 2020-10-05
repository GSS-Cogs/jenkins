variable "project" {
  description = "Project ID"
  type        = string
  default     = "optimum-bonbon-257411"
}

variable "region" {
  description = "Default region assumed to be London"
  type        = string
  default     = "europe-west2"
}

variable "env" {
  description = "Environment e.g. dev"
  default     = "dev"
}
