#################################################
# VPC
#################################################

resource "aws_vpc" "mt_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
	Name = "${local.app_name}-vpc"
  }
}

#################################################
# Public Subnet 
#################################################

resource "aws_internet_gateway" "mt_ig" {
  vpc_id = aws_vpc.mt_vpc.id
  tags = {
	Name = "${local.app_name}-ig"
  }
}

resource "aws_subnet" "mt_pub" {
  vpc_id = aws_vpc.mt_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "ap-northeast-1a"
  tags = {
	Name = "${local.app_name}-pub"
  }
}

#################################################
# Private Subnet
#################################################

resource "aws_subnet" "mt_pri" {
  vpc_id = aws_vpc.mt_vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "ap-northeast-1a"
  tags = {
	Name = "${local.app_name}-pri"
  }
}

#################################################
# Public Subnet Route Table
#################################################

resource "aws_route_table" "mt_rt_pub" {
  vpc_id = aws_vpc.mt_vpc.id
  route {
	cidr_block = "0.0.0.0/0"
	gateway_id = aws_internet_gateway.mt_ig.id
  }
  tags = {
	Name = "${local.app_name}-pub-table"
  }
}

#################################################
# Public Route Table Association
#################################################

resource "aws_route_table_association" "pub_to_ig" {
  subnet_id = aws_subnet.mt_pub.id
  route_table_id = aws_route_table.mt_rt_pub.id
}

#################################################
# Private Subnet Route Table
#################################################

resource "aws_route_table" "mt_rt_pri" {
  vpc_id = aws_vpc.mt_vpc.id
  route {
	#I must change to natgateway id
	cidr_block = "0.0.0.0/0"
	gateway_id = aws_internet_gateway.mt_ig.id
  }
  tags = {
	Name = "${local.app_name}-pri-table"
  }
}

#################################################
# Private Route Table Association
#################################################

resource "aws_route_table_association" "pri_to_ig" {
  subnet_id = aws_subnet.mt_pri.id
  route_table_id = aws_route_table.mt_rt_pri.id
}
