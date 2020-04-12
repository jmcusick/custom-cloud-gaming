provider "aws" {
  region  = "us-west-2"
}

data "aws_ami" "amazon-linux-2" {
  most_recent = true
  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"

  ingress {
    description = "TLS from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "allow_minecraft" {
  name        = "allow_minecraft"
  description = "Allow Minecraft inbound traffic"

  ingress {
    description = "TLS from VPC"
    from_port   = 25565
    to_port     = 25565
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.amazon-linux-2.id
  instance_type = "t2.medium"
  security_groups = [
    "${aws_security_group.allow_ssh.name}", 
    "${aws_security_group.allow_minecraft.name}"
  ]
  key_name = "us_northwest_keypair"
  user_data = file("./minecraft_server_init.sh")

  tags = {
    Name = "HelloWorld"
  }
}

output "IP" {
    value = "${aws_instance.web.public_ip}"
}