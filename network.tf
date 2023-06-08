resource "aws_vpc" "dev-vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support = true

  tags = {
    Name = "dev-vpc"
  }
}

resource "aws_subnet" "lambda" {
  cidr_block = "10.0.1.0/24"
  vpc_id = aws_vpc.dev-vpc.id

  tags = {
    Name = "lambda-subnet"
  }
}
resource "aws_subnet" "RDS-memcache" {
  cidr_block = "10.0.2.0/24"
  vpc_id = aws_vpc.dev-vpc.id
  availability_zone = "us-west-2b"

  tags = {
    Name = "RDS-memcache-subnet"
  }
}

