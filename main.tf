provider "aws" {
  region = "us-east-1"
  profile = local.profile
}

# module "module1" {
#   source = "./modules/module1"
#   instance_type="t2.micro"
#   name_tag="Terraform ec2"
#   profile-user = local.profile
# }

module "module2" {
  source = "./modules/module2"
  # providers = {
  #   aws = aws
  # }
}

# module "module3" {
#   source = "./modules/module3"
#   providers = {
#     aws = aws
#   }
# }

# output "out_module1" {
#   value = module.module1.out_print
#   sensitive = false
# }

locals {
  profile="dev"
}
