resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = module.vpc.vpc_id

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
  vpc_id      = module.vpc.vpc_id

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

resource "aws_instance" "minecraft" {
  ami           = data.aws_ami.amazon-linux-2.id
  instance_type = var.instance_type
  subnet_id     = module.vpc.public_subnets[0]
  security_groups = [
    aws_security_group.allow_ssh.id,
    aws_security_group.allow_minecraft.id,
  ]
  key_name = var.key_pair
  user_data = templatefile(
    "${path.module}/resources/minecraft_server_init.tpl",
    {
      role_arn = aws_iam_role.ccg_minecraft_assumed_role.arn
      s3_bucket = var.world_bucket
      s3_object = var.s3_server_object
    }
  )
  iam_instance_profile = aws_iam_instance_profile.ccg_minecraft_implicit_instance_profile.name

  root_block_device {
    volume_size = 64
  }
  
  tags = {
    Name = "minecraft"
  }
}

