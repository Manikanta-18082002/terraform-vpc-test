resource "aws_vpc_peering_connection" "peering" {  # This resource type is LIST
  count = var.is_peering_required ? 1: 0 # Default value: false (0) So, No Peering, If 1 then peering will be created
  peer_vpc_id   = aws_vpc.main.id # Requestor VPC ID, Below is Acceptor VPC 
  vpc_id        = var.acceptor_vpc_id == "" ? data.aws_vpc.default.id : var.acceptor_vpc_id # IF Empty (True) Peer with default VPC
  auto_accept = var.acceptor_vpc_id == "" ? true : false # auto_accept : will work only both were in same acount
  tags = merge(
    var.common_tags,
    var.vpc_peering_tags,
    {
        Name = "${local.resource_name}" # Output: expense-dev
    }

  )
}

# Below is Peering (of 3 Subnets) with Default VPC 
resource "aws_route" "public_peering" { # Below true && Empty --> Then take only default VPC CIDR
  count = var.is_peering_required && var.acceptor_vpc_id == "" ? 1: 0 # Count is useful to control when resource is required
  route_table_id            = aws_route_table.public.id
  destination_cidr_block    = data.aws_vpc.default.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.peering[0].id # [0] or [count.index] # By default is 0
}


resource "aws_route" "private_peering" { 
  count = var.is_peering_required && var.acceptor_vpc_id == "" ? 1: 0 
  route_table_id            = aws_route_table.private.id
  destination_cidr_block    = data.aws_vpc.default.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.peering[0].id 
}

resource "aws_route" "database_peering" { 
  count = var.is_peering_required && var.acceptor_vpc_id == "" ? 1: 0 
  route_table_id            = aws_route_table.database.id
  destination_cidr_block    = data.aws_vpc.default.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.peering[0].id
}

# From Default VPC (of 1 Subnet) to Our Expense (Main route Table)
resource "aws_route" "default_peering" { 
  count = var.is_peering_required && var.acceptor_vpc_id == "" ? 1: 0 
  route_table_id            = data.aws_route_table.main.id # default VPC Route Table
  destination_cidr_block    = var.vpc_cidr # Connecting to Expense VPC from default VPC
  vpc_peering_connection_id = aws_vpc_peering_connection.peering[0].id
}


# Every VPC Have 1 default Route Table 