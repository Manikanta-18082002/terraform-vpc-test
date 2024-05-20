# ---------- Project ------------ #Forcing user to give below details
variable "project_name" { #Should give these values in --> vpc-test (Folder) -->variables.tf, 
    type = string 
            # If not provided (Error: prompt will display) in terraform plan
}

variable "environment" {
    type = string
    default = "dev"
  
}

variable "common_tags" { #Giving default values there --> vpc-test --> variables.tf
    type = map
  
}

# ------------- VPC ---------
variable "vpc_cidr" {
    type = string
    default = "10.0.0.0/16"
}

variable "enable_dns_hostnames" {
    type = bool
    default = true
  
}

variable "vpc_tags" { #Optional
    type = map
    default = {}
}

# ---------- IGW ------------
variable "igw_tags" {
    type = map
    default = {}
}

# ---------------- Public Subnet -------------
variable "public_subnet_cidrs" { #Mandatory
    type = list
    validation {
      condition = length(var.public_subnet_cidrs) == 2 #We are using: 10.0.1.0/24, 10.0.2.0/24 --> In vpc-test -->variables.tf
      error_message = "Please provide only 2 valid public subnet CIDR"
    }
}

variable "public_subnet_cidr_tags" { #Optional
    type  = map
    default = {}
}

# ---------------- Private Subnet -------------
variable "private_subnet_cidrs" {
    type = list
    validation {
      condition = length(var.private_subnet_cidrs) == 2 #We are using: 10.0.1.0/24, 10.0.2.0/24 --> In vpc-test -->variables.tf
      error_message = "Please provide only 2 valid public subnet CIDR"
    }
}

variable "private_subnet_cidr_tags" {
    type  = map
    default = {}
}


# ---------------- Database Subnet -------------
variable "database_subnet_cidrs" {
    type = list
    validation {
      condition = length(var.database_subnet_cidrs) == 2 #We are using: 10.0.1.0/24, 10.0.2.0/24 --> In vpc-test -->variables.tf
      error_message = "Please provide only 2 valid public subnet CIDR"
    }
}

variable "database_subnet_cidr_tags" {
    type  = map
    default = {}
}

variable "nat_gateway_tags" {
    type = map
    default = {}
}

variable "public_route_table_tags" {
    type = map
    default = {}
}

variable "private_route_table_tags" {
    type = map
    default = {}
}

variable "database_route_table_tags" {
    type = map
    default = {}
}