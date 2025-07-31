locals {
  eks_cluster_name = "${local.name_prefix}-eks-${var.eks_cluster_name}"

}

resource "aws_eks_cluster" "eks_cluster" {

  name = local.eks_cluster_name

  access_config {
    authentication_mode = "API"
  }

  role_arn = aws_iam_role.eks_cluster_iam_role.arn
  version  = var.eks_cluster_version

  vpc_config {
    subnet_ids = [for subnet in aws_subnet.eks_cluster_pvt_subnets : subnet.id]

    endpoint_private_access = false
    endpoint_public_access  = true
  }

  tags = merge(local.common_tags, {
    Name = "${local.eks_cluster_name}-cluster"
  })

  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_role_policy_attachment,
  ]
}


resource "aws_eks_node_group" "eks_cluster_main_node_group" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  version         = var.eks_cluster_version
  node_group_name = "${local.eks_cluster_name}-node-group"
  node_role_arn   = aws_iam_role.eks_nodes_iam_role.arn

  subnet_ids = [for subnet in aws_subnet.eks_cluster_pvt_subnets : subnet.id]

  capacity_type  = "ON_DEMAND"
  instance_types = [var.eks_cluster_instance_type]

  ami_type = var.eks_cluster_ami_type

  scaling_config {
    desired_size = var.eks_cluster_desired_nodes
    max_size     = var.eks_cluster_max_nodes
    min_size     = var.eks_cluster_min_nodes
  }

  update_config {
    max_unavailable = 1
  }

  labels = var.eks_cluster_labels

  depends_on = [
    aws_iam_role_policy_attachment.eks_worker_node_role_policy_attachment,
    aws_iam_role_policy_attachment.eks_cni_role_policy_attachment,
    aws_iam_role_policy_attachment.eks_ec2_container_registry_role_policy_attachment,
  ]

  # Allow external changes without Terraform plan difference
  lifecycle {
    ignore_changes = [scaling_config[0].desired_size]
  }

  tags = merge(local.common_tags, {
    Name = "${local.eks_cluster_name}-node-group"
  })
}