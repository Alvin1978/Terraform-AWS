# URL to Article: "Steps to Deploy AWS workspace"
# https://blog.knoldus.com/how-to-deploy-aws-workspaces-in-aws-using-terraform/

# Step 3: Deploying the Network 
module "vpc" {

  source = "terraform-aws-modules/vpc/aws"
  name = "demo-dev"
  cidr = "10.10.0.0/16"

  azs             = ["eu-north-1-cph-1a", "eu-north-1-cph-1a"]
  private_subnets = ["10.10.1.0/24", "10.10.2.0/24"]
  public_subnets  = ["10.10.3.0/24", "10.10.4.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = true
  one_nat_gateway_per_az = false
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "demo-dev"
    Environment = "Development"
  }

}