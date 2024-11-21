resource "helm_release" "aws_load_balancer_controller" {
  name = "aws-load-balancer-controller"

  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  namespace  = "kube-system"
  version    = "1.10.0"
  timeout    = 300

  set {
    name  = "clusterName"
    value = aws_eks_cluster.eks.name
  }

  set {
    name  = "serviceAccount.name"
    value = "aws-load-balancer-controller"
  }

  set {
    name  = "vpcId"
    value = data.terraform_remote_state.vpc.outputs.vpc_id
  }

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = aws_iam_role.aws_load_balancer_controller.arn
  }

  depends_on = [
    aws_eks_node_group.general,
    aws_iam_role_policy_attachment.aws_load_balancer_controller_attach
  ]
}

data "terraform_remote_state" "route53" {
  backend = "s3"
  config = {
    bucket = "prd-aws-tf-state-backend"
    key    = "terraform/prd/route53/terraform.tfstate"
    region = "us-east-1"
  }
}

resource "helm_release" "external-dns" {
  name = "external-dns"

  repository = "https://charts.bitnami.com/bitnami"
  chart      = "external-dns"
  namespace  = "kube-system"
  version    = "8.5.1"

  set {
    name  = "clusterName"
    value = aws_eks_cluster.eks.id
  }

  set {
    name  = "serviceAccount.name"
    value = "external-dns"
  }

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = aws_iam_role.external_dns.arn
  }

  set {
    name  = "txtOwnerId"
    value = data.terraform_remote_state.route53.outputs.route53_zone_id
  }

  set {
    name  = "policy"
    value = "sync"
  }

  depends_on = [
    aws_eks_node_group.general,
    aws_iam_role_policy_attachment.external_dns_attach,
    helm_release.aws_load_balancer_controller
  ]
}