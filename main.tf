
provider "aws" {
  region     = "eu-west-1"
  profile    = "default"
}

# resource "aws_instance" "ec2_instance" {
#   count                     = "${var.count}"
#   //name                      = "instance_${var.Name}_${var.count}"
#   ami                       = "${var.ami}"
#   instance_type             = "${var.instance_type}"
#   key_name                  = "${var.key_name}"
#   vpc_security_group_ids    = ["${var.vpc_security_group_ids}",]
#   subnet_id                 = "${var.subnet_id}"

resource "aws_instance" "jenkins_server_amr" {
  ami           = "ami-06358f49b5839867c"
  instance_type = "t2.micro"
  key_name      = "amr"
  user_data     = "${file("jenkins_script.sh")}"
  
  provisioner "local-exec" {
    command = "echo ${aws_instance.jenkins_server_amr.public_ip} > ip_address.txt"
  }

  tags = {
      Name = "example_tf"
    }
}

resource "aws_eip" "first_amr_ip" {
    vpc = true
    instance = "aws_instance.jenkins_server_amr.id"
}

output "first_amr_ip" {
  value = aws_eip.first_amr_ip.public_ip
}
