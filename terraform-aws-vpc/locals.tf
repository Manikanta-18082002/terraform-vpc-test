locals {
  resource_name = "${var.project_name}-${var.environment}" #Output: expense-dev
  az_names = slice(data.aws_availability_zones.available.names,0,2) #Output: us-east-1a,1b
}