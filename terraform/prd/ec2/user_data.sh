#! /bin/bash

exit_on_failure()
{
    exit_code=${1}
    message=${2}
    if [ ${exit_code} -ne 0 ]; then
        echo "${message}, exit code:${exit_code}"
        exit ${exit_code}
    fi
}

env="prd"
cloud="aws"
name="devops-gha-runner"
region="us-east-1"
gha_token_name=${env}-github-actions-token
suffix=$(head /dev/urandom | tr -dc a-z0-9 | head -c 6)

timedatectl set-timezone Asia/Jerusalem
hostnamectl set-hostname ${name}

apt-get update
apt-get -y install expect jq unzip nfs-common ca-certificates curl gnupg gh apt-transport-https

curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
chmod +x kubectl
mkdir -p ~/.local/bin
mv ./kubectl ~/.local/bin/kubectl

install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get -y update
apt-get -y install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
usermod -aG docker ubuntu

sysctl -w net.core.somaxconn=50000

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
./aws/install
rm -rf awscliv2.zip

access_key="$(aws secretsmanager get-secret-value --secret-id prd-aws-credentials --query SecretString --region $region --output text | jq -r '.ACCESS_KEY')"
secret_key="$(aws secretsmanager get-secret-value --secret-id prd-aws-credentials --query SecretString --region $region --output text | jq -r '.SECRET_ACCESS_KEY')"

echo "[default]" > /home/ubuntu/.aws/config
echo "region = $region" >> /home/ubuntu/.aws/config
echo "output = text" >> /home/ubuntu/.aws/config

echo "[default]" > /home/ubuntu/.aws/credentials
echo "aws_access_key_id = $access_key" >> /home/ubuntu/.aws/credentials
echo "aws_secret_access_key = $secret_key" >> /home/ubuntu/.aws/credentials

apt-get update && sudo apt-get install -y gnupg software-properties-common
wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null
gpg --no-default-keyring --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg --fingerprint
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/hashicorp.list
apt update
apt-get install -y terraform packer

### github actions runner setup ###

instance_id=$(curl http://169.254.169.254/latest/meta-data/instance-id)
aws ec2 create-tags --resources ${instance_id} --tags Key=Name,Value=${env}-${name}-${suffix}

github_token="$(aws secretsmanager get-secret-value --secret-id ${gha_token_name} --query SecretString --region $region --output text)"
exit_on_failure $? "Failed to query ${env}-${name} token from secrets manager"

github_repo_url="https://github.com/dgrdevops/scores"
github_runner_version="2.320.0"

mkdir /home/ubuntu/actions-runner && cd /home/ubuntu/actions-runner
curl -o actions-runner-linux-x64-${github_runner_version}.tar.gz -L https://github.com/actions/runner/releases/download/v${github_runner_version}/actions-runner-linux-x64-${github_runner_version}.tar.gz
tar xzf ./actions-runner-linux-x64-${github_runner_version}.tar.gz
chown -R ubuntu:ubuntu /home/ubuntu/actions-runner
su - ubuntu -c 'cd /home/ubuntu/actions-runner/ && ./config.sh --url '${github_repo_url}' --token '${github_token}' --name '${cloud}-${env}-${name}-${suffix}' --labels '${env}-${name}' --replace --unattended'
su - ubuntu -c '/home/ubuntu/actions-runner/run.sh &'