provider "aws" {
  region     = "us-east-1"  # Change if needed
  access_key = ""
  secret_key = ""
}

# Get default VPC and Subnets
data "aws_vpc" "default" {
  default = true
}

data "aws_subnet" "default" {
  filter{
     name = "default-for-az"
     values = ["true"]
   }
  filter{
     name = "availability-zone"
     values = ["us-east-1a"]
   }
}

# Allow SSH access
resource "aws_security_group" "ssh_access" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Open to all (use your IP range in production)
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Launch EC2 Instance
resource "aws_instance" "m2" {
  ami                         = "ami-0f9de6e2d2f067fca"  # Example Amazon Linux 2 AMI for us-east-1
  instance_type               = "t2.medium"
  key_name                    = "devops-project"          # Replace with your existing key pair name
  subnet_id                   = data.aws_subnet.default.id
  vpc_security_group_ids      = [aws_security_group.ssh_access.id]

  tags = {
    Name = "master-VM"
  }
}
resource "aws_instance" "m3" {
  ami                         = "ami-0f9de6e2d2f067fca"  # Example Amazon Linux 2 AMI for us-east-1
  instance_type               = "t2.medium"
  key_name                    = "devops-project"          # Replace with your existing key pair name
  subnet_id                   = data.aws_subnet.default.id
  vpc_security_group_ids      = [aws_security_group.ssh_access.id]

  tags = {
    Name = "slave-VM1"
  }
}
resource "aws_instance" "m4" {
  ami                         = "ami-0f9de6e2d2f067fca"  # Example Amazon Linux 2 AMI for us-east-1
  instance_type               = "t2.medium"
  key_name                    = "devops-project"          # Replace with your existing key pair name
  subnet_id                   = data.aws_subnet.default.id
  vpc_security_group_ids      = [aws_security_group.ssh_access.id]

  tags = {
    Name = "slave-VM2"
  }
}
