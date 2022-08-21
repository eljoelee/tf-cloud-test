locals {
  subnets = [
    {
        name = "public-beer-subnet-1"
        zone = "ap-northeast-2a"
        cidr = "172.10.1.0/24"
    },
    {
        name = "public-beer-subnet-2"
        zone = "ap-northeast-2b"
        cidr = "172.10.2.0/24"
    },
    {
        name = "public-beer-subnet-3"
        zone = "ap-northeast-2c"
        cidr = "172.10.3.0/24"
    },
  ]
}

resource "aws_vpc" "beer" {
    cidr_block = "172.10.0.0/16"
    enable_dns_hostnames = true

    tags = {
        Name = "vpc-beer-ecs"
    }
}

resource "aws_subnet" "public-beer" {
    count = length(local.subnets)
    
    vpc_id = aws_vpc.beer.id

    cidr_block = local.subnets[count.index].cidr
    availability_zone = local.subnets[count.index].zone
    
    map_public_ip_on_launch = true
    
    tags = {
        Name = local.subnets[count.index].name
    }
}

resource "aws_internet_gateway" "igw-beer" {
    vpc_id = aws_vpc.beer.id
}

resource "aws_route_table" "rtb-beer" {
    vpc_id = aws_vpc.beer.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw-beer.id
    }

    tags = {
        Name = "public_beer_rtb"
    }
}

resource "aws_route_table_association" "asc-beer" {
    for_each = {for k,v in aws_subnet.public-beer: k => v.id}
    subnet_id = each.value
    route_table_id = aws_route_table.rtb-beer.id
}