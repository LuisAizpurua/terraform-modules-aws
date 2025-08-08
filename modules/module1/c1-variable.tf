variable "instance_type" {
    description = "instance type EC2"
    type = string
}


variable "name_tag" {
  description = "tag EC2"
  type = string
}

variable "profile-user" {
  description = "profile user"
  type = string
  default = "dev"
}