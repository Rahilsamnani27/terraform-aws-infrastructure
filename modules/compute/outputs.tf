output "instance_id" {
  value = aws_instance.app.id
}

output "public_ip" {
  value = aws_instance.app.public_ip
}

output "iam_role_name" {
  value = aws_iam_role.ec2_role.name
}
