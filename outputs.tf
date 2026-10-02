# Consumidos pelos próximos projetos (tf-ec2, tf-elasticache, tf-alb) via
# terraform_remote_state no bucket tf-Klinsync (key tf-vpc/terraform.tfstate).

output "vpc_id" {
  description = "ID da VPC Klinsync"
  value       = module.vpc.vpc_id
}

output "vpc_cidr_block" {
  description = "CIDR da VPC"
  value       = module.vpc.vpc_cidr_block
}

output "public_subnets" {
  description = "IDs das subnets públicas (fase atual: todas as EC2s)"
  value       = module.vpc.public_subnets
}

output "private_subnets" {
  description = "IDs das subnets privadas (fase atual: todas as EC2s)"
  value       = module.vpc.private_subnets
}

output "public_route_table_ids" {
  description = "Route tables públicas (associadas ao gateway endpoint S3)"
  value       = module.vpc.public_route_table_ids
}

output "private_route_table_ids" {
  description = "Route tables privadas (associadas ao gateway endpoint S3)"
  value       = module.vpc.private_route_table_ids
}

output "azs" {
  description = "AZs utilizadas"
  value       = module.vpc.azs
}
output "flow_logs_bucket" {
  description = "Bucket S3 dos VPC Flow Logs"
  value       = module.vpc.vpc_flow_log_destination_arn
}