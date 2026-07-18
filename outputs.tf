output "vpc_id" {
  value = module.network.vpc_id
}

output "ec2_public_ip" {
  value       = module.compute.public_ip
  description = "SSH here, and hit http://<this-ip>:8000/health once the app is running"
}

output "s3_bucket_name" {
  value = module.storage.bucket_name
}

output "rds_endpoint" {
  value       = module.database.endpoint
  description = "Use this as the DB host when connecting the app to Postgres"
}
