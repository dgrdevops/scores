import boto3

RESET = "\033[0m"
RED = "\033[91m"
CYAN = "\033[96m"

def list_regions():
    """List all AWS regions."""
    ec2_client = boto3.client('ec2', region_name='us-east-1')
    response = ec2_client.describe_regions()
    regions = [region['RegionName'] for region in response['Regions']]
    return regions

def list_ec2_instances(region):
    """List EC2 instances in a region."""
    ec2_client = boto3.client('ec2', region_name=region)
    instances = ec2_client.describe_instances()
    return instances['Reservations']

def list_rds_instances(region):
    """List RDS instances in a region."""
    rds_client = boto3.client('rds', region_name=region)
    instances = rds_client.describe_db_instances()
    return instances['DBInstances']

def list_aws_services(region):
    """List all AWS services and resources in the region."""
    print(f"{CYAN}Region: {region}{RESET}")
    
    # EC2 Instances
    ec2_instances = list_ec2_instances(region)
    if ec2_instances:
        print(f"  {CYAN}EC2 Instances in {region}:{RESET}")
        for reservation in ec2_instances:
            for instance in reservation['Instances']:
                instance_id = instance['InstanceId']
                state = instance['State']['Name']
                print(f"    {RED}- Instance ID: {instance_id}, State: {state}{RESET}")
    else:
        print(f"  No EC2 instances found in {region}.")
    
    rds_instances = list_rds_instances(region)
    if rds_instances:
        print(f"  {CYAN}RDS Instances in {region}:{RESET}")
        for rds in rds_instances:
            db_id = rds['DBInstanceIdentifier']
            status = rds['DBInstanceStatus']
            print(f"    {RED}- DB Instance ID: {db_id}, Status: {status}{RESET}")
    else:
        print(f"  No RDS instances found in {region}.")

def main():
    """Main function to list services used in all regions."""
    regions = list_regions()
    for region in regions:
        list_aws_services(region)
        print("-" * 50)

if __name__ == "__main__":
    main()
