 module "vpc" {
    source = "/mnt/c/Users/siddh/OneDrive/Desktop/practice terraform/sid-terrform/resources/vpc"
    my_vpc = "12.11.0.0/16"
    pub_subnet = "12.11.0.0/17"
    pvt_subnet = "12.11.128.0/19"
    my_igw = "my_igw"
    my_route = "route"
}


module "ec2" {
    source = "/mnt/c/Users/siddh/OneDrive/Desktop/practice terraform/sid-terrform/resources/ec2"
    my_instance_instance_type = "t2.micro"
    aws_instance_key_name = "n.virginia"
    aws_instance_availability_zone = "us-east-1a"
    aws_instance_volume_size = 8

}
  
