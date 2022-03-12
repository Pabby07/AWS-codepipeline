provider "aws" {
    region = "us-east-1"
    access_key = "AKIAXMUC7YGV54QGXYUZ"
    secret_key = "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"
}

resource "aws_instance" "web" {
  ami           = "ami-033b95fb8079dc481"
  instance_type = "t2.micro"

  tags = {
    Name = "HelloWorld"
  }
}

output "ec2_IP" {
  value = aws_instance.web.public_ip
}