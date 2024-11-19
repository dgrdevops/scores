resource "aws_iam_role" "eks" {
  name = "${var.env}-${local.application_name}-role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "eks" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks.name
}

data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "prd-aws-tf-state-backend"
    key    = "terraform/prd/vpc/terraform.tfstate"
    region = "us-east-1"
  }
}

data "terraform_remote_state" "ec2" {
  backend = "s3"
  config = {
    bucket = "prd-aws-tf-state-backend"
    key    = "terraform/prd/ec2/terraform.tfstate"
    region = "us-east-1"
  }
}

resource "aws_eks_cluster" "eks" {
  name     = "${var.env}-${local.application_name}"
  version  = local.eks_version
  role_arn = aws_iam_role.eks.arn

  vpc_config {
    endpoint_private_access = true
    endpoint_public_access  = true

    subnet_ids = [
      data.terraform_remote_state.vpc.outputs.private_subnet1_id,
      data.terraform_remote_state.vpc.outputs.private_subnet2_id
    ]
  }

  depends_on = [aws_iam_role_policy_attachment.eks]
}

resource "aws_vpc_security_group_ingress_rule" "allow_from_gha_runner" {
  security_group_id            = aws_eks_cluster.eks.vpc_config[0].cluster_security_group_id
  referenced_security_group_id = data.terraform_remote_state.ec2.outputs.ec2_devops_gha_runner_sg_id
  ip_protocol                  = "-1"
}

#################### EBS CSI DRIVER ADDON ####################
resource "aws_eks_addon" "ebs_csi_driver" {
  cluster_name             = aws_eks_cluster.eks.name
  addon_name               = "aws-ebs-csi-driver"
  addon_version            = local.ebs_driver_version
  service_account_role_arn = aws_iam_role.eks_ebs_csi_driver.arn

  depends_on = [aws_eks_node_group.general]
}

data "aws_iam_policy_document" "ebs_csi" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.eks.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:ebs-csi-controller-sa"]
    }

    principals {
      identifiers = [aws_iam_openid_connect_provider.eks.arn]
      type        = "Federated"
    }
  }
}

resource "aws_iam_role" "eks_ebs_csi_driver" {
  assume_role_policy = data.aws_iam_policy_document.ebs_csi.json
  name               = "${aws_eks_cluster.eks.name}-ebs-csi-driver"
}

resource "aws_iam_role_policy_attachment" "amazon_ebs_csi_driver" {
  role       = aws_iam_role.eks_ebs_csi_driver.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
}

#################### EFS CSI DRIVER ADDON ####################
resource "aws_eks_addon" "efs_csi_driver" {
  cluster_name             = aws_eks_cluster.eks.name
  addon_name               = "aws-efs-csi-driver"
  addon_version            = local.efs_driver_version
  service_account_role_arn = aws_iam_role.eks_efs_csi_driver.arn

  depends_on = [aws_eks_node_group.general]
}

data "aws_iam_policy_document" "efs_csi" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.eks.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:efs-csi-controller-sa"]
    }

    principals {
      identifiers = [aws_iam_openid_connect_provider.eks.arn]
      type        = "Federated"
    }
  }
}

resource "aws_iam_role" "eks_efs_csi_driver" {
  assume_role_policy = data.aws_iam_policy_document.efs_csi.json
  name               = "${aws_eks_cluster.eks.name}-efs-csi-driver"
}

resource "aws_iam_role_policy_attachment" "amazon_efs_csi_driver" {
  role       = aws_iam_role.eks_efs_csi_driver.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEFSCSIDriverPolicy"
}

#################### Set GP3 default storage class ####################
resource "kubernetes_annotations" "gp2_default" {
  annotations = {
    "storageclass.kubernetes.io/is-default-class" : "false"
  }
  api_version = "storage.k8s.io/v1"
  kind        = "StorageClass"
  metadata {
    name = "gp2"
  }

  force = true

  depends_on = [aws_eks_addon.ebs_csi_driver]
}

resource "kubernetes_storage_class" "ebs_csi_gp3_storage_class" {
  metadata {
    name = "gp3"
    annotations = {
      "storageclass.kubernetes.io/is-default-class" : "true"
    }
  }

  storage_provisioner    = "ebs.csi.aws.com"
  reclaim_policy         = "Delete"
  allow_volume_expansion = true
  volume_binding_mode    = "WaitForFirstConsumer"
  parameters = {
    fsType    = "ext4"
    encrypted = true
    type      = "gp3"
  }

  depends_on = [kubernetes_annotations.gp2_default]
}