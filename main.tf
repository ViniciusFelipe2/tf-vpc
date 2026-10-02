module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 6.6.1"

  name = "Klinsync-prod-vpc"
  cidr = "10.1.0.0/23"

  azs              = ["us-east-2a", "us-east-2b", "us-east-2c"]
  public_subnets   = ["10.1.0.0/27", "10.1.0.32/27", "10.1.0.64/27"]
  private_subnets  = ["10.1.0.96/27", "10.1.0.128/27", "10.1.0.160/27"]
  database_subnets = ["10.1.0.192/27", "10.1.0.224/27", "10.1.1.0/27"]

  default_security_group_name = "Klinsync-sg"

  # Database subnet route table — isolated, no internet and no NAT route
  # PostgreSQL EC2 will live here and must not have outbound internet access
  create_database_subnet_route_table     = true
  create_database_internet_gateway_route = false
  create_database_nat_gateway_route      = false

  manage_default_route_table = false

  # NAT Gateway — disabled (no internet egress from private/db subnets yet).
  # single_nat_gateway stays true even with NAT disabled: it's also what
  # collapses private/database route tables to 1 shared table across all 3
  # AZs instead of 1-per-subnet (module ties both to the same flag).
  enable_nat_gateway = false
  single_nat_gateway = true
  enable_vpn_gateway = false

  enable_dhcp_options  = true
  enable_dns_hostnames = true
  enable_dns_support   = true

  # VPC Flow Logs (Cloudwatch log group and IAM role will be created)
  enable_flow_log                       = true
  create_flow_log_cloudwatch_log_group  = true
  create_flow_log_cloudwatch_iam_role   = true
  flow_log_max_aggregation_interval     = 60
  vpc_flow_log_iam_role_name            = "AMZ-Klinsync-flow-logs"
  vpc_flow_log_iam_role_use_name_prefix = false
  flow_log_destination_type             = "s3"
  flow_log_destination_arn              = "arn:aws:s3:::logs-vpc-klinsync"

  # Security Groups
  default_security_group_ingress = [
    {
      type        = "ingress"
      description = "Allow HTTPS from ALB"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

  default_security_group_egress = [
    {
      type        = "egress"
      description = "Allow all outbound traffic"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

  tags = {
    Terraform    = "True"
    Environment  = "Production"
    CI-CD        = "Github Actions"
    Organization = "Klinsync"
  }
}
