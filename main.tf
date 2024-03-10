resource "aws_vpc" "main" {
  cidr_block       = var.cidr_block
  instance_tenancy = "default"

  tags = merge(
    var.common_tags, 
    var.vpc_tags,
    {
        Name = "${local.name}"
    }
  )
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  
  tags = merge(
    var.common_tags, 
    var.igw_tags,
    {
        Name = "${local.name}"
    }
  )
  
}

# creating public subnets

resource "aws_subnet" "public" {
  count = length(var.public_subnets_cidr)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.public_subnets_cidr[count.index]
  availability_zone = local.azs[count.index]
  tags = {
    Name = "${local.name}-public-${local.azs[count.index]}"
  }
}

# creating private subnets

resource "aws_subnet" "private" {
  count = length(var.private_subnets_cidr)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.private_subnets_cidr[count.index]
  availability_zone = local.azs[count.index]
  tags = {
    Name = "${local.name}-private-${local.azs[count.index]}"
  }
}

# creating database subnets

resource "aws_subnet" "database" {
  count = length(var.database_subnets_cidr)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.database_subnets_cidr[count.index]
  availability_zone = local.azs[count.index]
  tags = {
    Name = "${local.name}-database-${local.azs[count.index]}"
    
  }
}


resource "aws_db_subnet_group" "default" {
  name       = "${local.name}"
  subnet_ids = aws_subnet.database[*].id

  tags = {
    Name = "${local.name}"
  }
}


#creating elastic ip 

resource "aws_eip" "eip" {
  domain   = "vpc"
 
}

resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.public[0].id

  tags = merge(
    var.common_tags,
    var.nat_gateway_tags,
    {
        Name = "${local.name}"
    }
  )
  

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
 depends_on = [aws_internet_gateway.igw]
  }

# create public route table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.common_tags,
    var.public_route_table_tags,
    {
        Name = "${local.name}-public"
    }
  )
}  

#create private route table
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

tags = merge(
    var.common_tags,
    var.private_route_table_tags,
    {
        Name = "${local.name}-private"
    }
  )
}

# create database route table
resource "aws_route_table" "database" {
  vpc_id = aws_vpc.main.id


  tags = merge(
    var.common_tags,
    var.database_route_table_tags,
    {
        Name = "${local.name}-database"
    }
  )
}

# create public routes

resource "aws_route" "public" {
  route_table_id            = aws_route_table.public.id
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.main.id
}

# create public routes
resource "aws_route" "private" {
  route_table_id            = aws_route_table.private.id
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.main.id
}

# create public routes
resource "aws_route" "database" {
  route_table_id            = aws_route_table.database.id
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.main.id
}

# associate route table with public subnet
resource "aws_route_table_association" "public" {
  count = length(var.public_subnets_cidr)
  subnet_id      = element(aws_subnet.public[*].id,count.index)
  route_table_id = aws_route_table.public.id
}

# associate route table with private subnet
resource "aws_route_table_association" "private" {
  count = length(var.private_subnets_cidr)
  subnet_id      = element(aws_subnet.private[*].id,count.index)
  route_table_id = aws_route_table.private.id
}

# associate route table with database subnet
resource "aws_route_table_association" "database" {
  count = length(var.database_subnets_cidr)
  subnet_id      = element(aws_subnet.database[*].id,count.index)
  route_table_id = aws_route_table.database.id
}