# Create a VPC
resource "aws_vpc" "tf_lab_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags = {
      Name = "TF Lab VPC"
  }
}

# Create a subnet inside VPC
resource "aws_subnet" "public_subnet_1" {
  vpc_id     = aws_vpc.tf_lab_vpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "TF Public subnet 1"
  }
}

# Create Internet Gateway to connect Internet
resource "aws_internet_gateway" "igw1" {
  vpc_id = aws_vpc.tf_lab_vpc.id

  tags = {
    Name = "TF Internet Gateway 1"
  }
}

# Create route table. All traffic to Internet is directed to Internet Gateway
resource "aws_route_table" "tf_public_route_table" {
  vpc_id = aws_vpc.tf_lab_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw1.id
  }

  tags = {
    Name = "TF Public Route 1"
  }
}

# Associate route table with subnet
resource "aws_route_table_association" "tf_public_subnet_1_assoc" {
    subnet_id = aws_subnet.public_subnet_1.id
    route_table_id = aws_route_table.tf_public_route_table.id
}