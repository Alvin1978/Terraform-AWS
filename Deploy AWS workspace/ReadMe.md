# AWS Toolkit for Visual Studio Code
<https://aws.amazon.com/visualstudiocode/>  

Install from vscode Extention Marketplace.  
[](vscode:extension/amazonwebservices.aws-toolkit-vscode)

# Amazon WorkSpaces

## Step 1: Create three files

```Powershell
New-Item -type file provider.tf, resource.tf, module.tf
```

## Step 2: Define the Provider

We will define the provider with an access key and secret key. In this deployment, I will use the credential profile name. We can simply define credentials with profile by just execute the below command:  
aws configure --profile <profile_name>  

```aws
aws configure --profile "terraform"
```

We will store this script in the file: ***provider.tf***.  

```hcl
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.0.0"
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
        region  = "eu-north-1"
}
```

## Step 3: Deploying the Network 

