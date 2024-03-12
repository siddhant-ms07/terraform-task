  //VPC
resource "aws_vpc" "my_vpc" {
    cidr_block = var.my_vpc
    tags = {
      Name = "my_vpc"
    }
}
 
 //SUBNET
 resource "aws_subnet" "pub_subnet" {
    vpc_id = aws_vpc.my_vpc.id
    cidr_block = var.pub_subnet
    
    tags = {
        name = "pub_subnet"
    }  
}

resource "aws_subnet" "pvt_subnet" {
    vpc_id = aws_vpc.my_vpc.id
    cidr_block = var.pvt_subnet

    tags = {
        name = "pvt_subnet"
    }
}


//internet gateway
resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.my_vpc.id

    tags = {
      name = var.my_igw
    }
}

//route table
resource "aws_route_table" "route" {
    vpc_id =  aws_vpc.my_vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }

    tags = {
        name = var.my_route
    }
}

//association subnet with route
resource "aws_route_table_association" "route_association" {
     route_table_id = aws_route_table.route.id
     subnet_id = aws_subnet.pub_subnet.id
}