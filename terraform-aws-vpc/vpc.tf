resource "aws_vpc" "main" {
    cidr_block       = var.vpc_cidr
    instance_tenancy = "default"
    enable_dns_hostnames = var.enable_dns_hostnames
    tags = merge(
        var.common_tags,
        var.vpc_tags,
        {
            Name = local.resource_name
        }
    )
}

# IGW
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id #Attaching IGW to VPC

  tags = merge(
    var.common_tags,
    var.igw_tags,
    {
            Name = local.resource_name
    }
  )
}
# Public SUBNET
resource "aws_subnet" "public" { #First Name is: public[0], Second Name is: public[1]
  count = length(var.public_subnet_cidrs)
  availability_zone = local.az_names[count.index]
  map_public_ip_on_launch = true
  
  vpc_id     = aws_vpc.main.id
  cidr_block = var.public_subnet_cidrs[count.index]

  tags = merge(
    var.common_tags,
    var.public_subnet_cidr_tags,
    {
            Name = "${local.resource_name}-public-${local.az_names[count.index]}" #expense-dev-us-east-1a/1b
    }
  )
}

# Private Subnet
resource "aws_subnet" "private" {
  count = length(var.private_subnet_cidrs)
  availability_zone = local.az_names[count.index]
  # map_public_ip_on_launch = true #For private subnets we shouldn't get public IPS so false (Simply comment)
  
  vpc_id     = aws_vpc.main.id
  cidr_block = var.private_subnet_cidrs[count.index]

  tags = merge(
    var.common_tags,
    var.private_subnet_cidr_tags,
    {
            Name = "${local.resource_name}-private-${local.az_names[count.index]}" #expense-dev-us-east-1a/1b
    }
  )
}

# Database Subnet
resource "aws_subnet" "database" {
  count = length(var.database_subnet_cidrs)
  availability_zone = local.az_names[count.index]
  # map_public_ip_on_launch = true #For private it's false (Simply comment it)
  
  vpc_id     = aws_vpc.main.id
  cidr_block = var.database_subnet_cidrs[count.index]

  tags = merge(
    var.common_tags,
    var.database_subnet_cidr_tags,
    {
            Name = "${local.resource_name}-database-${local.az_names[count.index]}" #expense-dev-us-east-1a/1b
    } #Above total is Interpolation: mixing of variables + text
  )
}

# Elastic IP --> eip
resource "aws_eip" "nat" {
  domain = "vpc"
  
}
# NAT --> Network Address Translator
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id

  tags = merge(
    var.common_tags,
    var.nat_gateway_tags,
    {
            Name = "${local.resource_name}" # expense-dev
    }
  )

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.gw] # This is explicit dependency, Saying: Create IGW then NAT Gatway

#If internet Gateway is not there then NAT Gateway is no need
}

# ------ Public Route Table -------
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

 tags = merge(
    var.common_tags,
    var.public_route_table_tags,
    {
            Name = "${local.resource_name}-public" # expense-dev
    }
  )
}


# ------ Private Route Table -------
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

 tags = merge(
    var.common_tags,
    var.private_route_table_tags,
    {
            Name = "${local.resource_name}-private" # expense-dev
    }
  )
}

# ------ Database Route Table -------
resource "aws_route_table" "database" {
  vpc_id = aws_vpc.main.id

 tags = merge(
    var.common_tags,
    var.database_route_table_tags,
    {
            Name = "${local.resource_name}-database" # expense-dev
    }
  )
}

# Creates in AWS RDS --> Subnet Groups (Left side)
# For High Availability DB Subnet Group: --> All DB Subnet's we created (2) adding to the Group
resource "aws_db_subnet_group" "default" {
  name       = "${local.resource_name}"
  subnet_ids = aws_subnet.database[*].id # T0 get all (2) the DB Subnet's ID

  tags = merge(
    var.common_tags,
    var.database_subnet_group_tags,
    {
            Name = "${local.resource_name}"
    }
  )
}


# ---- Routes ---------
resource "aws_route" "public" {
  route_table_id            = aws_route_table.public.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.gw.id
}

resource "aws_route" "private_nat" {
  route_table_id = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.nat.id
}

resource "aws_route" "database_nat" {
  route_table_id = aws_route_table.database.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.nat.id
}


# ---- Route table and subnet Assosiation---------
resource "aws_route_table_association" "public" {
  count = length(var.public_subnet_cidrs)
  subnet_id = element(aws_subnet.public[*].id, count.index) # Fetches 0th, 1st id from list
  route_table_id = aws_route_table.public.id
  
}
resource "aws_route_table_association" "private" {
  count = length(var.private_subnet_cidrs)
  subnet_id = element(aws_subnet.private[*].id, count.index)
  route_table_id = aws_route_table.private.id
  
}
resource "aws_route_table_association" "database" {
  count = length(var.database_subnet_cidrs)
  subnet_id = element(aws_subnet.database[*].id, count.index)
  route_table_id = aws_route_table.database.id
  
}

