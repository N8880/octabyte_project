# Configure AWS provider
provider "aws" {
  region = "us-east-1"  # Change to your preferred region
}

# Create VPC, subnets, and NAT gateway
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"  # Use version 5.x (current stable)

  name = "octa-byte-vpc"
  cidr = "10.0.0.0/16"
  azs  = ["us-east-1a", "us-east-1b"]

  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets = ["10.0.3.0/24", "10.0.4.0/24"]

  enable_nat_gateway = true
}

# Security group for EC2
resource "aws_security_group" "app_sg" {
  name        = "app-sg"
  description = "Allow HTTP and SSH"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["152.57.104.120/32"]  # Replace YOUR_IP with your public IP
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# RHEL EC2 Instance
resource "aws_instance" "app_server" {
  ami           = "ami-06640050dc3f556bb"  # RHEL 9.0 in us-east-1
  instance_type = "t2.micro"
  subnet_id     = module.vpc.public_subnets[0]
  vpc_security_group_ids = [aws_security_group.app_sg.id]
  key_name      = "niranjan_key"  # Replace with your key pair name
  associate_public_ip_address = true  # ✅ This enables public IP

  user_data = <<-EOF
              #!/bin/bash
              sudo dnf update -y
              sudo dnf install -y docker
              sudo systemctl start docker
              sudo docker run -d -p 80:80 nginx
              EOF

  tags = {
    Name = "OctaByte-App-Server"
  }
}
