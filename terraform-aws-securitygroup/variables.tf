variable "project_name" {
    type = string
}

variable "environment" {
    type = string
}

variable "sg_name" {
    type = string
}

variable "sg_description" {
    type = string
}

variable "vpc_id" {
    type = string
}

variable "common_tags" {
    type = map
}

variable "sg_tags" {
    type = map
    default = {}
}

variable "outbound_rules" {
    type = list
    default =  [
        { # We are giving this as Default 
        from_port = 0 # All Ports
        to_port = 0 
        protocol = "-1" # All Protocols
        cidr_blocks = ["0.0.0.0/0"]  # If user's Need they can Over ride this, and they can give any rules
    }
    ]
}

variable "ingress_rules" { # We don't know what user's need. So, Give empty
    type = list
    default = []
}