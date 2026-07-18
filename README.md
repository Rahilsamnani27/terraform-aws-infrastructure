# AWS Infrastructure as Code — Terraform

Provisions a small but realistic AWS environment entirely from code: a VPC with
public and private subnets, an EC2 instance, an S3 bucket, an IAM role (no
hardcoded credentials on the instance), and an RDS PostgreSQL database — all
reproducible with `terraform apply` and fully removable with `terraform destroy`.

## Why this project exists

Project 1 (CI/CD pipeline) required manually clicking through the AWS Console
to create the EC2 instance and security group. This project replaces that
manual process with code — the actual practice of "Infrastructure as Code" —
and adds networking concepts (VPC, subnets, route tables) and a managed
database (RDS) that Project 1 didn't touch.

## Network design

```
VPC (10.0.0.0/16)
│
├── Public subnets (10.0.1.0/24, 10.0.2.0/24) — one per AZ
│     └── route: 0.0.0.0/0 → Internet Gateway
│     └── hosts: EC2 instance (web-sg: 22 from admin IP, 8000 from anywhere)
│
└── Private subnets (10.0.11.0/24, 10.0.12.0/24) — one per AZ
      └── route: local VPC traffic only (no Internet Gateway, no NAT Gateway)
      └── hosts: RDS PostgreSQL (db-sg: 5432 from web-sg only, never public)
```

**Why no NAT Gateway:** a NAT Gateway costs roughly $32/month just to exist,
and this project's private subnet only needs to host RDS — which doesn't need
outbound internet access, only reachability from the EC2 instance inside the
same VPC. Skipping the NAT Gateway keeps this project genuinely free-tier.

**Security group design:** the database security group only accepts traffic
from the web security group (referenced by ID, not by CIDR) — so even if
someone found the RDS endpoint, it's unreachable from anywhere except the
app server itself.

## Module structure

```
.
├── main.tf              # wires all modules together
├── variables.tf          # root-level input variables
├── outputs.tf            # VPC ID, EC2 public IP, S3 bucket name, RDS endpoint
├── versions.tf           # provider requirements
├── modules/
│   ├── network/          # VPC, subnets, route tables, security groups
│   ├── storage/          # S3 bucket (public access blocked)
│   ├── compute/          # EC2 instance + IAM role (S3 read/write, no static keys)
│   └── database/         # RDS PostgreSQL, private subnet only
```

## Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform/install) >= 1.5.0
- An AWS account with an access key configured (`aws configure` or environment variables)
- An existing EC2 key pair in your target region

## Usage

```bash
cp terraform.tfvars.example terraform.tfvars
# edit terraform.tfvars: set key_pair_name and my_ip_cidr

# Never commit a real db_password — set it via environment variable instead:
export TF_VAR_db_password="your-strong-password-here"   # Linux/Mac
# $env:TF_VAR_db_password = "your-strong-password-here"  # Windows PowerShell

terraform init
terraform fmt -recursive
terraform validate
terraform plan
terraform apply
```

Or using the Makefile:
```bash
make init
make plan
make apply
```

When you're done:
```bash
make destroy
```
This is the key advantage over Project 1's manual teardown — one command
removes the VPC, subnets, EC2 instance, S3 bucket, and RDS database together,
with no risk of forgetting a resource and leaving it billing.

## Outputs

After `apply`, Terraform prints:
- `vpc_id` — the created VPC
- `ec2_public_ip` — SSH here, or hit `http://<ip>:8000/health` once the app is deployed
- `s3_bucket_name` — the app storage bucket
- `rds_endpoint` — use as the DB host when connecting the app to Postgres

## Cost notes

- EC2 `t3.micro` and RDS `db.t3.micro` are both free-tier eligible.
- No NAT Gateway, no Elastic IP, no Multi-AZ RDS — all avoided specifically to
  keep this at $0 for a short-lived demo.
- Always run `terraform destroy` (or delete via Console) after taking your
  screenshots — nothing here is meant to run 24/7.
