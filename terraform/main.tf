data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

resource "aws_ecr_repository" "svc" {
  for_each     = toset(["user-service", "product-service", "order-service"])
  name         = each.key
  force_delete = true
}

resource "aws_security_group" "app" {
  name = "microservices-sg"
  ingress { 
    from_port = 22   
    to_port = 22   
    protocol = "tcp" 
    cidr_blocks = [var.my_ip] 
  }
  ingress { 
    from_port = 80   
    to_port = 80   
    protocol = "tcp" 
    cidr_blocks = ["0.0.0.0/0"] 
  }
  ingress { 
    from_port = 3000 
    to_port = 3000 
    protocol = "tcp" 
    cidr_blocks = [var.my_ip] 
  }
  ingress { 
    from_port = 9090 
    to_port = 9090 
    protocol = "tcp" 
    cidr_blocks = [var.my_ip] 
  }
  egress  { 
    from_port = 0 
    to_port = 0 
    protocol = "-1" 
    cidr_blocks = ["0.0.0.0/0"] 
  }
}

resource "aws_iam_role" "ec2" {
  name = "ec2-ecr-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{ Effect = "Allow", Action = "sts:AssumeRole",
                   Principal = { Service = "ec2.amazonaws.com" } }]
  })
}
resource "aws_iam_role_policy_attachment" "ecr_read" {
  role       = aws_iam_role.ec2.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}
resource "aws_iam_instance_profile" "ec2" {
  name = "ec2-ecr-profile"
  role = aws_iam_role.ec2.name
}

resource "aws_instance" "app" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.app.id]
  iam_instance_profile   = aws_iam_instance_profile.ec2.name
  user_data = <<-EOF
    #!/bin/bash
    apt-get update -y
    apt-get install -y docker.io docker-compose-v2 unzip curl
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o /tmp/aws.zip
    unzip /tmp/aws.zip -d /tmp && /tmp/aws/install
    usermod -aG docker ubuntu
    systemctl enable --now docker
  EOF
  root_block_device { volume_size = 20 }
  tags = { Name = "microservices-host" }
}
