import boto3

def list_regions():
    """List all AWS regions."""
    ec2_client = boto3.client('ec2', region_name='us-east-1')  # Set the region here
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
    print(f"Region: {region}")
    
    # EC2 Instances
    ec2_instances = list_ec2_instances(region)
    print(f"EC2 Instances in {region}:")
    for instance in ec2_instances:
        print(f"  - Instance ID: {instance['Instances'][0]['InstanceId']}, State: {instance['Instances'][0]['State']['Name']}")
    
    # RDS Instances
    rds_instances = list_rds_instances(region)
    print(f"RDS Instances in {region}:")
    for rds in rds_instances:
        print(f"  - DB Instance ID: {rds['DBInstanceIdentifier']}, Status: {rds['DBInstanceStatus']}")

def main():
    """Main function to list services used in all regions."""
    regions = list_regions()
    for region in regions:
        list_aws_services(region)

if __name__ == "__main__":
    main()
