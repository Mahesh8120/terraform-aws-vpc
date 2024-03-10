variable "cidr_block" {
  default = "10.0.0.0/16"
}

variable "common_tags" {
  default = {}
}

variable "vpc_tags" {
  default = {}
}

variable "project_name" {
  type = string
}

variable "environment" {
 type = string 
}

variable "igw_tags" {
  default={}
}
variable "public_subnets_cidr" {
  default = {}
}

variable "private_subnets_cidr" {
  default = {}
}

variable "database_subnets_cidr" {
  default = ["10.0.21.0/24","10.0.22.0/24"]
}

variable "nat_gateway_tags" {
  default = {

  }
}

variable "public_route_table_tags" {
  default = {}
}

variable "private_route_table_tags" {
 default = {}

}

variable "database_route_table_tags" {
  default = {}
}

variable "is_peering_required" {
  type = bool
  default = false
}

variable "acceptor_vpc_id" {
  type = string
  default = ""
}

variable "vpc_peering_tags" {
  default = {}
}



