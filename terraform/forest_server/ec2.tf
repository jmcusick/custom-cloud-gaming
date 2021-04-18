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

resource "aws_security_group" "allow_forest" {
  name        = "allow_forest"
  description = "Allow Forest inbound traffic"

  ingress {
    description = "TLS from VPC"
    from_port   = 8766
    to_port     = 8766
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "TLS from VPC"
    from_port   = 8766
    to_port     = 8766
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "TLS from VPC"
    from_port   = 27015
    to_port     = 27015
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "TLS from VPC"
    from_port   = 27015
    to_port     = 27015
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "TLS from VPC"
    from_port   = 27016
    to_port     = 27016
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "TLS from VPC"
    from_port   = 27016
    to_port     = 27016
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "forest" {
  ami           = data.aws_ami.amazon-linux-2.id
  instance_type = var.instance_type
  security_groups = [
    aws_security_group.allow_ssh.name, 
    aws_security_group.allow_forest.name
  ]
  key_name = var.key_pair
  user_data = data.template_file.forest_server_init_script.rendered
  iam_instance_profile = aws_iam_instance_profile.ccg_forest_implicit_instance_profile.name

  root_block_device {
    volume_size = 64
  }
  
  tags = {
    Name = "forest"
  }
}

