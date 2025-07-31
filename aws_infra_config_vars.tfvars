//////// Global configuration variables

owner               = "sre"
environment         = "DEV"

eks_cluster_name    = "main-cluster"
eks_cluster_version = "1.33"
vpc_cidr            = "10.0.0.0/16"

eks_cluster_instance_type = "t4g.small"
eks_cluster_ami_type = "AL2023_ARM_64_STANDARD"
private_subnets_cidr = ["10.0.0.0/20", "10.0.16.0/20"]
public_subnets_cidr  = ["10.0.32.0/20", "10.0.64.0/20"]

eks_cluster_labels = {
    role = "general"
}
