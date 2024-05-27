# Simply to check the Information
# output "azs" {
#     value = data.aws_availability_zones.available.names
  
# }
#Outputs--> It prints the Information of the resources, this will be used in module development

# Below are the Minimum resources we display. We can output all resources
output "vpc_id" {
    value = aws_vpc.main.id
}

output "public_subnet_ids" { #ids ? Plural
    value = aws_subnet.public[*].id
}

output "private_subnet_ids" {
    value =  aws_subnet.private[*].id
}

output "databse_subnet_ids" {
    value =  aws_subnet.database[*].id
}

output "database_subnet_group_id" {
    value = aws_db_subnet_group.default.id
}

output "database_subnet_group_name" {
    value = aws_db_subnet_group.default.name
}

output "igw_id" {
    value = aws_internet_gateway.gw.id
  
}