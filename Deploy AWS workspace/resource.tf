# URL to Article: "Steps to Deploy AWS workspace"
# https://blog.knoldus.com/how-to-deploy-aws-workspaces-in-aws-using-terraform/


# Step 4: Deploying the AWS Managed Directory Service
resource "aws_directory_service_directory" "aws-managed-ad" {

  name = "demo.local"
  description = "Terraform Managed Directory Service"
  password = "Admin@123"
  edition = "Standard"
  type = "MicrosoftAD"

  vpc_settings {

    vpc_id = module.vpc.vpc_id
    subnet_ids = module.vpc.private_subnets
  }

  tags = {
    Name = "Muzakkir-managed-ad"
    Environment = "Development"
  }

}

# Step 5: Updating the DHCP Options in the VPC to Use AWS Directory Service DNS Servers
resource "aws_vpc_dhcp_options" "dns_resolver" {

  domain_name_servers = aws_directory_service_directory.aws-managed-ad.dns_ip_addresses
  domain_name = "demolocal"

  tags = {

    Name = "demo-dev"
    Environment = "Development"

  }

}




resource "aws_vpc_dhcp_options_association" "dns_resolver" {

  vpc_id = module.vpc.vpc_id
  dhcp_options_id = aws_vpc_dhcp_options.dns_resolver.id
  
}


# Step 6 : Defining the IAM role for workspace
data "aws_iam_policy_document" "workspaces" {

  statement {

    actions = ["sts:AssumeRole"]

    principals {

      type = "Service"
      identifiers = ["workspaces.amazonaws.com"]

    }

  }

}


resource "aws_iam_role" "workspaces-default" {

  name = "workspaces_DefaultRole"
  assume_role_policy = data.aws_iam_policy_document.workspaces.json

}

resource "aws_iam_role_policy_attachment" "workspaces-default-service-access" {

  role = aws_iam_role.workspaces-default.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonWorkSpacesServiceAccess"

}

resource "aws_iam_role_policy_attachment" "workspaces-default-self-service-access" {

  role = aws_iam_role.workspaces-default.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonWorkSpacesSelfServiceAccess"

}

# Step 7 : Defining an AWS WorkSpaces Directory
resource "aws_workspaces_directory" "workspaces-directory" {

 directory_id = aws_directory_service_directory.aws-managed-ad.id
  subnet_ids   = module.vpc.private_subnets
  depends_on = [aws_iam_role.workspaces-default]

}


# Step 8: List of WorkSpaces Bundles

// We will need the Amazon WorkSpaces Bundle IDs to launch the WorkSpaces. To get the list, we need to open the AWS CloudShell or an AWS CLI Console and type:

// aws workspaces describe-workspace-bundles --owner AMAZON 

# Step 9 : -> provider.tf

# Step 10: Defining a KMS to Encrypt WorkSpaces Disk Volumes
resource "aws_kms_key" "workspaces-kms" {

  description = "Muzakkir  KMS"
  deletion_window_in_days = 7

}

# Step 11: Defining an Amazon WorkSpaces (Deploy Workspaces)

resource "aws_workspaces_workspace" "workspaces" {

  directory_id = aws_workspaces_directory.workspaces-directory.id
  bundle_id = data.aws_workspaces_bundle.standard_linux.id

  # Admin is the Administrator of the AWS Directory Service

  user_name = "Admin"
  root_volume_encryption_enabled = true
  user_volume_encryption_enabled = true
  volume_encryption_key = aws_kms_key.workspaces-kms.arn

  workspace_properties {

    compute_type_name = "STANDARD"
    user_volume_size_gib = 50
    root_volume_size_gib = 80
    running_mode = "AUTO_STOP"
    running_mode_auto_stop_timeout_in_minutes = 60

  }

  tags = {

    Name = "demo-workspaces"
    Environment = "dev"

  }

  depends_on = [

    aws_iam_role.workspaces-default,
    aws_workspaces_directory.workspaces-directory

  ]

}

