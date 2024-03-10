This module will help to create following resources. NOTE: For High Availability(HA), I have used 2 AZ-(us-east-1a, us-east-1b).

Created VPC
Created internet gateway(igw) and attached to VPC
Created 2 public subnets in 1a and 1b
Created 2 private subnets in 1a and 1b
Created 2 database subnets in 1a and 1b
Created database subnet group in rds
Created Elastic ip
Created NAT gateway in 1a public subnet
Created route tables for public, private, database
Created routes for public with igw, private and database with NAT gateway
Subnets and route tables association
VPC peering if user requests
Adding the peering route in default VPC, if user don't provide acceptor VPC explicitly.
Adding the peering routes in public, private and database route tables
INPUTS
project_name(Required) - your project name
environment(Required) - environment you are working in
vpc_cidr(Optional) - default value cidr(10.0.0.0/16), user can override
enable_dns_hostnames(Optional) - default value is true
common_tags(Optional) - it will be useful if provided
vpc_tags(Optional) - default is empty, type is map
igw_tags(Optional) - default is empty, type is map
public_subnet_tags(Optional) - default is empty, type is map
public_subnets_cidr(Required) - user must provide 2 valid public subnet CIDR
publict_subnet_tags(Optional) - default is empty, type is map
private_subnet_cidr(Required) - user must provide 2 valid private subnet CIDR
private_subnet_tags(Optional) - default is empty, type is map
database_subnet_cidr(Required) - user must provide 2 valid private subnet CIDR
database_subnet_tags(Optional) - default is empty, type is map
nat_gateway_tags(Optional) - default is empty, type is map
public_route_table_tags(Optional) - default is empty, type is map
private_route_table_tags(Optional) - default is empty, type is map
database_route_table_tags(Optional)- default is empty, type is map
is vpc peering requird (Optional) - default value is false
acceptor_vpc_id(Optional) - default value is default VPC ID
vpc_peering_tags(Optional) - default is empty, type is map
OUTPUTS
vpc_id - VPC ID created
public_subnet_ids - 2 public subnet ID created
private_subnet_ids - 2 private subnet ID created
database_subnet_ids - 2 database subnet ID created
