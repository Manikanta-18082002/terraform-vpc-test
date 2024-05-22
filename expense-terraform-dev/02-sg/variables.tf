variable "project_name" {
    default = "expense"
}

variable "environment" {
    default = "dev" 
}

variable "common_tags" {
    default = {
        Project = "expnse"
        Environment = "dev"
        Terraform = "true"
    } 
}

# variable "db_sg_description" {
#     default = "Security Group for DB MYSQL Instances"
  
# }