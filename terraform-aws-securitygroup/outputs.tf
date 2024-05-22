output "sg_id" {
    value = aws_security_group.allow_tls.id
  
}

# 1st They need to expose then module user can catch and keep it in parameter store