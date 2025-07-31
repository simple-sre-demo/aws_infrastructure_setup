////// Data resources

data "aws_availability_zones" "eks_cluster_availability_zones" {
  state = "available"
}

////// VPC

resource "aws_vpc" "eks_cluster_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(local.common_tags, {
      Name = "${local.eks_cluster_name}-vpc"
    }
  )
}

////// Internet Gateway

resource "aws_internet_gateway" "eks_cluster_igw" {
  vpc_id = aws_vpc.eks_cluster_vpc.id

  tags = {
      Name = "${local.eks_cluster_name}-igw"
  }
}

////// Subnets

resource "aws_subnet" "eks_cluster_pvt_subnets" {

  count             = length(var.private_subnets_cidr)

  vpc_id            = aws_vpc.eks_cluster_vpc.id
  cidr_block        = var.private_subnets_cidr[count.index]
  availability_zone = data.aws_availability_zones.eks_cluster_availability_zones.names[count.index]

  tags = merge(local.common_tags, {
    Name                                              = "${local.eks_cluster_name}-pvt-subnet-${count.index + 1}"
    "kubernetes.io/cluster/${local.eks_cluster_name}" = "owned"
    "kubernetes.io/role/internal-elb"                 = "1"
  })
}

resource "aws_subnet" "eks_cluster_pub_subnets" {
  count             = length(var.public_subnets_cidr)
  vpc_id            = aws_vpc.eks_cluster_vpc.id
  cidr_block        = var.public_subnets_cidr[count.index]
  availability_zone = data.aws_availability_zones.eks_cluster_availability_zones.names[count.index]

  tags = merge(local.common_tags, {
    Name                                              = "${local.eks_cluster_name}-pub-subnet-${count.index + 1}"
    "kubernetes.io/cluster/${local.eks_cluster_name}" = "owned"
    "kubernetes.io/role/internal-elb"                 = "1"
  })
}

////// NAT Gateway

resource "aws_eip" "eks_cluster_eip" {

  # count      = length(aws_subnet.pub_subnets_cidr)

  domain     = "vpc"

  depends_on = [aws_internet_gateway.eks_cluster_igw]

   tags = merge(local.common_tags, {
      Name = "${var.eks_cluster_name}-eip"
  })
}

resource "aws_nat_gateway" "eks_cluster_nat" {

  allocation_id = aws_eip.eks_cluster_eip.id
  subnet_id     = aws_subnet.eks_cluster_pub_subnets[0].id

  tags = merge(local.common_tags, {
    Name = "${var.eks_cluster_name}-nat"
  })

  depends_on = [aws_internet_gateway.eks_cluster_igw]
}


////// Route tables

resource "aws_route_table" "eks_cluster_pvt_rt" {

  vpc_id = aws_vpc.eks_cluster_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.eks_cluster_nat.id
  }

  tags = merge(local.common_tags, {
    Name = "${var.eks_cluster_name}-pvt-rt"
  })
}

resource "aws_route_table_association" "eks_cluster_pvt_rt_association" {

  count          = length(aws_subnet.eks_cluster_pvt_subnets)

  subnet_id      = aws_subnet.eks_cluster_pvt_subnets[count.index].id
  route_table_id = aws_route_table.eks_cluster_pvt_rt.id
}

resource "aws_route_table" "eks_cluster_pub_rt" {

  vpc_id = aws_vpc.eks_cluster_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.eks_cluster_igw.id
  }

  tags = {
    Name = "${var.eks_cluster_name}-pub-rt"
  }
}

resource "aws_route_table_association" "eks_cluster_pub_rt_association" {

  count          = length(aws_subnet.eks_cluster_pub_subnets)

  subnet_id      = aws_subnet.eks_cluster_pub_subnets[count.index].id
  route_table_id = aws_route_table.eks_cluster_pub_rt.id
}