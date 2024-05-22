resource "aws_ssm_parameter" "vpc_id" {
  name  = "/${var.project_name}/${var.environment}/vpc_ID"  #Output: /expense/dev/vpc_ID
  type  = "String" # Capital S (AWS Notation)
  value = module.vpc.vpc_id # to get vpc_id (We need to expose in outputs --> terraform-aws-vpc)
}


# SSM:  provides secure, hierarchical storage for configuration data management and secrets management.
# --> Why we need SSM (Systems Manager) -> AWS --> Parameter Store --> Create

# Use:
# We have 01_VPC, 02_SG to get data from 1 -> Like VPC_ID, Subnet_ID Store in SSM