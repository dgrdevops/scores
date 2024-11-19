#!/bin/bash

declare -a directories=(
    "terraform/prd/vpc"
    "terraform/prd/route53"
    "terraform/prd/ec2"
    "terraform/prd/ecr"
    "terraform/prd/eks"
    "terraform/prd/rds"
)

cd scores || { echo "Failed to enter 'scores' directory"; exit 1; }

for dir in "${directories[@]}"; do
    echo "Processing directory: $dir"
    cd "$dir" || { echo "Failed to enter directory $dir"; exit 1; }
    
    echo "Initializing Terraform..."
    terraform init -input=false || { echo "Terraform init failed in $dir"; exit 1; }
    
    echo "Planning Terraform changes..."
    terraform plan -input=false || { echo "Terraform plan failed in $dir"; exit 1; }
    
    # echo "Applying Terraform changes..."
    # terraform apply -auto-approve || { echo "Terraform apply failed in $dir"; exit 1; }
    
    cd - > /dev/null || { echo "Failed to return to parent directory"; exit 1; }
done

echo "All Terraform configurations applied successfully."
