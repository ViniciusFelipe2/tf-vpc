# Gateway endpoint S3 — gratuito. Mantém o tráfego S3 (deploys, uploads,
# backups, logs) dentro da rede AWS, sem sair pela internet pública.
# Associado às route tables public/private/database: subnets privada e de
# database não têm NAT/IGW, então essa rota é o único caminho delas até o S3
# (ex.: backups do Postgres na subnet de database).
# Endpoints de interface (Secrets Manager, Bedrock, SSM...) só fazem sentido
# quando IA/BD migrarem para subnets privadas sem NAT — hoje a saída é pelo IGW.
module "vpc_endpoints" {
  source  = "terraform-aws-modules/vpc/aws//modules/vpc-endpoints"
  version = "~> 6.6.1"

  vpc_id = module.vpc.vpc_id

  endpoints = {
    s3 = {
      service      = "s3"
      service_type = "Gateway"
      route_table_ids = concat(
        module.vpc.public_route_table_ids,
        module.vpc.private_route_table_ids,
        module.vpc.database_route_table_ids,
      )
      tags = {
        Name        = "s3-endpoint-Klinsync"
        Environment = "Production"
      }
    }
  }

  tags = {
    Terraform    = "True"
    Environment  = "Production"
    CI-CD        = "Github Actions"
    Organization = "Klinsync"
  }
}
