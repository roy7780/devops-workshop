provider "aws"{
    region = "ap-south-1"
}

resource "aws_instance" "terra-demo" {
    ami = "ami-0b982602dbb32c5bd"
    instance_type = "t3.micro"
    key_name = "ops"
    vpc_security_group_ids = [aws_security_group.demo-sg.id]
    subnet_id = aws_subnet.demo_public_subnet_01.id
for_each = toset(["Jenkins-master", "build-slave", "ansible"])
    tags = {
      name = "${each.key}"
    }

}

resource "aws_security_group" "demo-sg" {
    name = "demo-sg"
    description = "SSH ACCESS"
    vpc_id = aws_vpc.demo_vpc.id
    
    ingress {
        description = "ssh"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_vpc" "demo_vpc" {
    cidr_block = "10.1.0.0/16"
    tags ={
        name = "demo_vpc"
    }

}

resource "aws_subnet" "demo_public_subnet_01" {
    vpc_id = aws_vpc.demo_vpc.id
    cidr_block = "10.1.1.0/24" 
    map_public_ip_on_launch = "true"
    availability_zone = "ap-south-1a"
    tags = {
        name = "demo_public_subnet_01"
    }

}

resource "aws_subnet" "demo_public_subnet_02" {
    vpc_id = aws_vpc.demo_vpc.id
    cidr_block = "10.1.2.0/24" 
    map_public_ip_on_launch = "true"
    availability_zone = "ap-south-1a"
    tags = {
        name = "demo_public_subnet_02"
    }
    
}

resource "aws_internet_gateway" "demo_igw" {
    vpc_id = aws_vpc.demo_vpc.id
    tags = {
      name = "demo_igw"
    }
}

resource "aws_route_table" "demo_public_rt" {
    vpc_id = aws_vpc.demo_vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.demo_igw.id
    }
  
}

resource "aws_route_table_association" "demo_rta_public_subnet_01" {
    subnet_id = aws_subnet.demo_public_subnet_01.id
    route_table_id = aws_route_table.demo_public_rt.id
    
}

resource "aws_route_table_association" "demo_rta_public_subnet_02" {
    subnet_id = aws_subnet.demo_public_subnet_02.id
    route_table_id = aws_route_table.demo_public_rt.id
    
}
    