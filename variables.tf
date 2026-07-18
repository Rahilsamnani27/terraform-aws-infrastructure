variable "aws_region" {
  description = "AWS region to deploy into"
  type        = string
  default     = "ap-south-1"
}

variable "project_name" {
  description = "Name prefix used for tagging and naming all resources"
  type        = string
  default     = "task-tracker"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets (one per AZ)"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets (one per AZ, used for RDS)"
  type        = list(string)
  default     = ["10.0.11.0/24", "10.0.12.0/24"]
}

variable "availability_zones" {
  description = "Availability zones to spread subnets across"
  type        = list(string)
  default     = ["ap-south-1a", "ap-south-1b"]
}

variable "instance_type" {
  description = "EC2 instance type (must be free-tier eligible)"
  type        = string
  default     = "t3.micro"
}

variable "key_pair_name" {
  description = "Name of an existing EC2 key pair for SSH access"
  type        = string
}

variable "my_ip_cidr" {
  description = "Your IP address in CIDR form (e.g. 1.2.3.4/32), used to restrict SSH access"
  type        = string
}

variable "db_name" {
  description = "Initial database name"
  type        = string
  default     = "tasktracker"
}

variable "db_username" {
  description = "Master username for RDS"
  type        = string
  default     = "appadmin"
}

variable "db_password" {
  description = "Master password for RDS (pass via terraform.tfvars or TF_VAR_db_password env var — never commit this)"
  type        = string
  sensitive   = true
}

variable "db_instance_class" {
  description = "RDS instance class (free-tier eligible)"
  type        = string
  default     = "db.t3.micro"
}
