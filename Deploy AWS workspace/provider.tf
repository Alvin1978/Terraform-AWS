# URL to Article: "Steps to Deploy AWS workspace"
# https://blog.knoldus.com/how-to-deploy-aws-workspaces-in-aws-using-terraform/

# Step 2: Define the Provider
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      #version = "5.0.0"
    }
   random = {
      source  = "hashicorp/random"
      version = "~>3.0"
    }
  }
}


provider "aws" {
  # Configuration options
        profile = "terraform"
        region  = "eu-west-1"
}


# Step 9 : Defining the Amazon WorkSpaces Bundle

 ## Run command in AWS CloudShell or an AWS CLI Console to get the list of all images.
# aws workspaces describe-workspace-bundles --owner AMAZON 

# aws workspaces describe-workspace-bundles --owner AMAZON --query "Bundles[].{BundleId:BundleId, Name:Name}"
# aws workspaces describe-workspace-bundles --owner AMAZON --query "Bundles[?contains(Name, 'Ubuntu')].{BundleId:BundleId, Name:Name}"
# aws workspaces describe-workspace-bundles --owner AMAZON --query "Bundles[?contains(Name, 'Windows')].{BundleId:BundleId, Name:Name}"

 ## This is a Windows Standard Bundle
 ### "Name": "Standard with Windows 10 (Server 2022 based) (WSP)",
# data "aws_workspaces_bundle" "standard_windows" {

# bundle_id = "wsb-93xk71ss4"
# }

 ##  This is a Linux Standard Bundle
 ###  "Name": "Standard with Ubuntu 22.04",
data "aws_workspaces_bundle" "standard_linux" {

 bundle_id = "wsb-g5rbnq51n"

}
