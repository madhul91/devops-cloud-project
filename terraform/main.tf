provider "aws" {
  region = var.region
}

# Get Default VPC
data "aws_vpc" "default" {
  default = true
}

# Get Default Subnet (any one)
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# ---------------- Security Group ----------------
resource "aws_security_group" "devops_sg" {
  name   = "devops-sg"
  vpc_id = data.aws_vpc.default.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "App Port"
    from_port   = 3000
    to_port     = 3000
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

# ---------------- EC2 ----------------
resource "aws_instance" "devops_ec2" {
  ami           = var.ami
  instance_type = "t2.micro"
  key_name      = var.key_name

  subnet_id              = data.aws_subnets.default.ids[0]
  vpc_security_group_ids = [aws_security_group.devops_sg.id]

  associate_public_ip_address = true

  tags = {
    Name = "DevOps-Docker-Server"
  }
}
