# data "aws_ssm_parameter" "vpc_ID" {
#   name = "/${var.project_name}/${var.environment}/vpc_ID" # Fetches values from --> /expnse/dev/vpc_ID
# }

data "aws_ssm_parameter" "vpc_id" {
  name = "/${var.project_name}/${var.environment}/vpc_id"
}

output "vpc_id" {
  value = data.aws_ssm_parameter.vpc_id.value
}
