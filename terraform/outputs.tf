output "ec2_public_ip" { value = aws_instance.app.public_ip }
output "ecr_urls"      { value = { for k, v in aws_ecr_repository.svc : k => v.repository_url } }
