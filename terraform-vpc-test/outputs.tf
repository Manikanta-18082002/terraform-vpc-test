# Catching that output here via modules

# output "azs_info" {
#     value = module.vpc.azs  # module.<module-name>.<output>
  
# }


output "vpc_id" {
    value = module.vpc.vpc_id # Name should be same from (aws-vpc --> Output) Catch output that publishes from (aws-vpc)
  
}

output "public_subnet_list" {
  value = module.vpc.public_subnet_ids
}
