# For Above 02-sg (Folder) we are developing a Seperate Module...(terraform-aws-securitygroup)

resource "aws_security_group" "allow_tls" {
  name        = local.sg_name_final # expense-dev-sg_name  #(This is Security Group Name(Final & Unique) not just Name)
  description = var.sg_description
  vpc_id      = var.vpc_id  # "vpc-12345678" 

    dynamic "ingress" { # Enhancing the Security even more.... by developing FULL Security 
    for_each = var.ingress_rules
    content {
        from_port       = ingress.value["from_port"]
        to_port         = ingress.value["to_port"]
        protocol        = ingress.value["protocol"]
        cidr_blocks = ingress.value["cidr_blocks"]
    }
  }

  dynamic "egress" {
    for_each = var.outbound_rules
    content {
        from_port       = egress.value["from_port"]
        to_port         = egress.value["to_port"]
        protocol        = egress.value["protocol"]
        cidr_blocks = egress.value["cidr_blocks"]
    }
  }

  tags = merge(
    var.common_tags,
    var.sg_tags,
    {
        Name = local.sg_name_final
    }
  )
}

# In Security Group for Out Bound --> Always Allow 0.0.0.0/0 --> Egress

# For more Secured Projects (Banking) Outboud they didn't allow for 0.0.0.0/0 (Allows only with in their company intranet)
# Then Creating dynamic Block for egress rules