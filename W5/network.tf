cat <<EOT > network.tf
provider "aws" {
  region  = "ap-northeast-2"
}

resource "aws_vpc" "beas-vpc" {
  cidr_block       = "10.10.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "t101-beas-vpc"
  }
}

resource "aws_subnet" "beas-subnet1" {
  vpc_id     = aws_vpc.beas-vpc.id
  cidr_block = "10.10.1.0/24"

  availability_zone = "ap-northeast-2a"

  tags = {
    Name = "t101-beas-subnet1"
  }
}

resource "aws_subnet" "beas-subnet2" {
  vpc_id     = aws_vpc.beas-vpc.id
  cidr_block = "10.10.2.0/24"

  availability_zone = "ap-northeast-2c"

  tags = {
    Name = "t101-beas-subnet2"
  }
}

resource "aws_internet_gateway" "beas-igw" {
  vpc_id = aws_vpc.beas-vpc.id

  tags = {
    Name = "t101-beas-igw"
  }
}

resource "aws_route_table" "beas-rt" {
  vpc_id = aws_vpc.beas-vpc.id

  tags = {
    Name = "t101-beas-rt"
  }
}

resource "aws_route_table_association" "beas-rtassociation1" {
  subnet_id      = aws_subnet.beas-subnet1.id
  route_table_id = aws_route_table.beas-rt.id
}

resource "aws_route_table_association" "beas-rtassociation2" {
  subnet_id      = aws_subnet.beas-subnet2.id
  route_table_id = aws_route_table.beas-rt.id
}

resource "aws_route" "beas-defaultroute" {
  route_table_id         = aws_route_table.beas-rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.beas-igw.id
}
EOT