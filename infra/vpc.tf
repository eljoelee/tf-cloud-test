resource "aws_vpc" "beer" {
    cidr_block = "172.10.0.0/16"
    enable_dns_hostnames = true

    tags = {
        Name = "vpc-beer-ecs"
    }
}

resource "aws_subnet" "public-beer" {
    count = 3
    vpc_id = aws_vpc.beer.id
    cidr_block = "172.10.${count.index + 1}.0/24"
    availability_zone = "ap-northeast-2a"

    tags = {
        Name = "public-beer-subnet-${count.index + 1}"
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
    for_each = aws_subnet.public-beer
    subnet_id = each.value.id
    route_table_id = aws_route_table.rtb-beer.id
}