# Implementation overview

1. **Global** - for policies and other stuff which is the same for every environment
2. **Terraform** - for cloud environment provisioning
3. **K8S** - manifests for kubernetes cluster containing flask-app deployment
4. **Tools** - python script with boto3 to list aws objects
5. Implementation as much as possible secured

## Terraform

### AWS terraform files and folders

0. variables - mostly modified file, containing hard coded records
1. providers - containing cloud provider records and default tags applied to all created resources
2. vpc - vpc with dns support
3. igw - internet gateway for public subnets
4. subnets - public and private subnets including necessary eks/alb tags
5. nat - network address translator providing internet access from private subnets
6. routes - necessary routes
7. eks - cluster, addons, role
8. nodes - eks cluster nodes running in private subnets, with access to ecr, including new node creation before destroy
9. irsa - certificate and open id connect to eks cluster
10. aws-loadbalancer - controller role
11. external-dns - controller role
12. helm - charts with values
13. output - necessary outputs after successful execution
14. backend - for terraform state stored in S3 and session lock stored in DynamoDB

* terraform flat implementation used for better visability
* trying maximum simulate production implementation

## K8S

- flask-app deployed in terraform inside EKS cluster demonstrating routed requsts
- deployed appropriate permissions to display all running pods in kube-system namespace
- application record created in Route53 by external-dns controller
- ingress alb created by aws-load-balancer controller


## Github workflows

- performs build image on PR
- performs image push and deploy on merge
- checks flask-app deployment status on merge
- for build purpose used auto-deployed self-hosted runner as ec2-instance with role
- list aws services can be executed by related workflow
- Tokens stored in AWS Secrets Manager

## Check running app

- do nslookup prd-scores-alb-113286380.us-east-1.elb.amazonaws.com
- update your /etc/hosts file with records (may change):
    54.243.74.241 demo.scores.xyz
    3.94.46.38 demo.scores.xyz
- try in browser:
    http://demo.scores.xyz/welcome
    http://demo.scores.xyz/kube-system-pods

### AWS terraform apply

```sh
git clone git@github.com:dgrdevops/365scores.git
cd 365scores/terraform/prd/vpc
terraform init
terraform plan
terraform apply -auto-approve

cd ../route53
terraform init
terraform plan
terraform apply -auto-approve

cd ../ec2
terraform init
terraform plan
terraform apply -auto-approve

cd ../ecr
terraform init
terraform plan
terraform apply -auto-approve

cd ../eks
terraform init
terraform plan
terraform apply -auto-approve

cd ../rds
terraform init
terraform plan
terraform apply -auto-approve
```