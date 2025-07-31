////// Global variables

variable "region" {
  description = "Region to which the infrastructure will be deployed."
  type        = string
  default     = "eu-central-1"

  validation {
    condition     = contains(["eu-central-1"], var.region) # Note: Update this list if expanding to other regions
    error_message = "ERROR - Region must be eu-central-1."
  }
}

variable "environment" {
  description = "Environment to which the infrastructure is deployed i.e. DEV or PROD."
  type        = string
  default     = "DEV"

  validation {
    condition     = contains(["DEV", "PROD"], var.environment) # Note: Update this list if adding more environments
    error_message = "ERROR - Environment must be development or production."
  }
}

variable "owner" {
  description = "Owner of the infrastructure to deploy e.g. sre."
  type        = string

  validation {
    condition     = length(var.owner) < 11
    error_message = "ERROR - Owner must have 10 characters max."
  }
}

////// Networking variables

variable "vpc_cidr" {
  description = "CIDR block for the VPC."
  type        = string
#   default     = "10.0.0.0/16"
}

variable "private_subnets_cidr" {
  description = "List of CIDR blocks for private subnets (for EKS nodes)."
  type        = list(string)
}

variable "public_subnets_cidr" {
  description = "List of CIDR blocks for public subnets (for ALB/Bastion)."
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
}

//////// EKS configuration variables

variable "eks_cluster_name" {
  description = "Name of the EKS cluster to deploy."
  type        = string
}

variable "eks_cluster_version" {
  description = "Version of the EKS cluster to deploy."
  type        = string
}

variable "eks_cluster_instance_type" {
  description = "EC2 instance type for EKS worker nodes."
  type        = string
  default     = "t3.medium"
}

variable "eks_cluster_ami_type" {
  description = "EC2 AMI type for EKS worker nodes."
  type        = string
  default     = "AL2023_x86_64_STANDARD"
}

variable "eks_cluster_desired_nodes" {
  description = "Desired number of EKS worker nodes."
  type        = number
  default     = 2
}

variable "eks_cluster_max_nodes" {
  description = "Maximum number of EKS worker nodes."
  type        = number
  default     = 3
}

variable "eks_cluster_min_nodes" {
  description = "Minimum number of EKS worker nodes."
  type        = number
  default     = 1
}

variable "eks_cluster_labels" {
  description = "Minimum number of EKS worker nodes."
  type        = map
  default     = {}
}