# Overview

- This terraform repo is designed to setup the infrastructure for `"list app"`
- This code requires storage account with a container for storing terraform state file 
- This code will create a resource group with a keyvault
- Any db login credentials can be generated and added to keyvault

#Structure

- backend-config
    - This contains Terraform backend configuration files that specify the Storage Account, storage container, and file for storing state
    - All secrets to be stored in environment variables
    - The backend config file is specified with the `terraform init` command
- tfvars
    - This contains the various tfvars files with values to configure deployments that target different environments
    - Create a `.tfvars` file for each target environment
    -  To target a specific deployment configuration, specify the .tfvars file with the `terraform plan` and `terraform apply` commands
- main.tf
    - The standard Terraform deployment configuration file.  This is designed to be reusable across environments by specifying a different `.tfvars` file for each environment
- outputs.tf
    - The standard Terraform output file
- variables.tf
    - The standard Terraform variables file