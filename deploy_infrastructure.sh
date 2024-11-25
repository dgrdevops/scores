#!/bin/bash

declare -a directories=(
    "terraform/prd/vpc"
    "terraform/prd/route53"
    "terraform/prd/ec2"
    "terraform/prd/ecr"
    "terraform/prd/eks"
    "terraform/prd/rds"
)

usage() {
    echo "Usage: $0 --init | --plan | --apply | --destroy"
    exit 1
}

if [ "$#" -ne 1 ]; then
    usage
fi

case "$1" in
    --init)
        action="init"
        ;;
    --plan)
        action="plan"
        ;;
    --apply)
        action="apply"
        ;;
    --destroy)
        action="destroy"
        ;;
    *)
        usage
        ;;
esac

for dir in "${directories[@]}"; do
    echo "Processing directory: $dir"
    cd "$dir" || { echo "Failed to enter directory $dir"; exit 1; }
    
    echo "Executing Terraform $action in $dir..."
    case "$action" in
        init)
            terraform init -input=false || { echo "Terraform init failed in $dir"; exit 1; }
            ;;
        plan)
            terraform init -input=false || { echo "Terraform init failed in $dir"; exit 1; }
            terraform plan -input=false || { echo "Terraform plan failed in $dir"; exit 1; }
            ;;
        apply)
            terraform init -input=false || { echo "Terraform init failed in $dir"; exit 1; }
            terraform plan -input=false || { echo "Terraform plan failed in $dir"; exit 1; }
            terraform apply -auto-approve || { echo "Terraform apply failed in $dir"; exit 1; }
            ;;
        destroy)
            terraform init -input=false || { echo "Terraform init failed in $dir"; exit 1; }
            terraform destroy -auto-approve || { echo "Terraform destroy failed in $dir"; exit 1; }
            ;;
    esac

    cd - > /dev/null || { echo "Failed to return to parent directory"; exit 1; }
done

echo "Terraform $action completed successfully for all directories."