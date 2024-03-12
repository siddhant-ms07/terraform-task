variable "my_instance_instance_type" {
    type = string
    default = "t2.micro"

}

variable "aws_instance_key_name" {
    type = string
    default = "n.virginia"  
}

variable "aws_instance_availability_zone" {
    type = string
    default = "us-east-1a"
}

variable "aws_instance_volume_size" {
    type = number
    default = 8
}
