
provider "aws" {
  region     = "eu-west-1"
  profile    = "default"
}

terraform {
 backend "s3" {
 encrypt = true
 bucket = "terraform5748585845"
 dynamodb_table = "terraform-state-lock-dynamo"
 region = "us-east-1"
 key = "apache-server/"
 }
}

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
