provider "aws" {
  region     = "us-east-1"
  access_key = "AKIAUMYXXCGSTEBSIBF3"
  secret_key = "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"
}
resource "aws_vpc" "green-vpc" {
  cidr_block = "10.10.0.0/16"
    tags = {Name = "projectGreen-vpc"}
}
/*Creation of igw*/
resource "aws_internet_gateway" "green-igw" {
    vpc_id = aws_vpc.green-vpc.id
	tags = {Name = "projectGreen-igw"}
}

/*Creation of subnets*/
resource "aws_subnet" "green-public-subnet-1a" {
  vpc_id     = aws_vpc.green-vpc.id
  cidr_block = "10.10.1.0/24"
  availability_zone = "us-east-1a"
  tags = {Name = "projectGreen-public-subnet-1a"}
}
resource "aws_subnet" "green-public-subnet-1b" {
  vpc_id     = aws_vpc.green-vpc.id
  cidr_block = "10.10.2.0/24"
  availability_zone = "us-east-1b"
  tags = {Name = "projectGreen-public-subnet-1b"}
}
resource "aws_subnet" "green-private-subnet-1c" {
  vpc_id     = aws_vpc.green-vpc.id
  cidr_block = "10.10.3.0/24"
  availability_zone = "us-east-1c"
  tags = {Name = "projectGreen-private-subnet-1c"}
}
resource "aws_subnet" "green-private-subnet-1d" {
  vpc_id     = aws_vpc.green-vpc.id
  cidr_block = "10.10.4.0/24"
  availability_zone = "us-east-1d"
  tags = {Name = "projectGreen-private-subnet-1d"}
}
/*Creation of route tables*/
resource "aws_route_table" "green-private-rt" {
  vpc_id = aws_vpc.green-vpc.id
  route {
      cidr_block = "0.0.0.0/0" 
      gateway_id = aws_nat_gateway.green-nat-gateway.id
    }
    tags = {Name = "projectGreen-private-rt"}
}
resource "aws_route_table" "green-public-rt" {
  vpc_id = aws_vpc.green-vpc.id
  route {
      cidr_block = "0.0.0.0/0" 
      gateway_id = aws_internet_gateway.green-igw.id
    }
    tags = {Name = "projectGreen-public-rt"}
}

/*Creation of elastic ip*/
resource "aws_eip" "green-eip" {
  vpc = true
}

/*Creation of nat gateway*/
resource "aws_nat_gateway" "green-nat-gateway" {
  allocation_id = aws_eip.green-eip.id
  subnet_id     = aws_subnet.green-public-subnet-1a.id
}

/*Route Table association*/
resource "aws_route_table_association" "green-pub2pub1-association" {
  subnet_id      = aws_subnet.green-public-subnet-1a.id
  route_table_id = aws_route_table.green-public-rt.id
}
resource "aws_route_table_association" "green-pub2pub2-association" {
  subnet_id      = aws_subnet.green-public-subnet-1b.id
  route_table_id = aws_route_table.green-public-rt.id
}

resource "aws_route_table_association" "green-pri2pri1-association" {
  subnet_id      = aws_subnet.green-private-subnet-1c.id
  route_table_id = aws_route_table.green-private-rt.id
}
resource "aws_route_table_association" "green-pri2pri2-association" {
  subnet_id      = aws_subnet.green-private-subnet-1d.id
  route_table_id = aws_route_table.green-private-rt.id
}

