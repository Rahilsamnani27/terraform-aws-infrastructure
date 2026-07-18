module "network" {
  source = "./modules/network"

  project_name         = var.project_name
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones   = var.availability_zones
  my_ip_cidr           = var.my_ip_cidr
}

module "storage" {
  source = "./modules/storage"

  project_name = var.project_name
}

module "compute" {
  source = "./modules/compute"

  project_name      = var.project_name
  instance_type     = var.instance_type
  key_pair_name     = var.key_pair_name
  subnet_id         = module.network.public_subnet_ids[0]
  security_group_id = module.network.web_security_group_id
  bucket_arn        = module.storage.bucket_arn
}

module "database" {
  source = "./modules/database"

  project_name       = var.project_name
  private_subnet_ids = module.network.private_subnet_ids
  security_group_id  = module.network.db_security_group_id
  db_name            = var.db_name
  db_username        = var.db_username
  db_password        = var.db_password
  db_instance_class  = var.db_instance_class
}
