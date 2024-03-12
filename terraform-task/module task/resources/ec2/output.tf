output "aws_ami" {
    value = aws_instance.my_instance.ami
}

output "aws_instance_type" {
    value = aws_instance.my_instance.instance_type
}

output "aws_instance_zone" {
    value = aws_instance.my_instance.availability_zone
}

