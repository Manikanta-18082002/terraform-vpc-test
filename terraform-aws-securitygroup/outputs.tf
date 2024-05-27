output "sg_id" {
    value = aws_security_group.allow_tls.id
  
}

output "vpc_id" {
  value = var.vpc_id
}


# 1st They need to expose then module user can catch and keep it in parameter store