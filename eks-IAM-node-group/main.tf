provider "aws" {
  region = var.region
}

resource "aws_vpc" "eks-vpc-terraform" {
  cidr_block = var.vpc_cidrblock

  tags = {
    owner     = local.owner
    costCentr = local.costCentr
  }
}

resource "aws_subnet" "public_subnets" {
  count      = length(var.public_subnets_cidr_block)
  vpc_id     = aws_vpc.eks-vpc-terraform.id
  cidr_block = element(var.public_subnets_cidr_block, count.index)
  availability_zone = element(var.public_subnets_azs, count.index)
  tags = {
    owner     = local.owner
    costCentr = local.costCentr
  }
}

# data "aws_vpc" "default" {
#   default = true
# }

# data "aws_subnets" "default_subnets" {

# }

resource "aws_eks_cluster" "eks-terraform" {
  name = "eks-terraform"

  role_arn = aws_iam_role.cluster.arn
  version  = "1.31"
  #   count    = length(var.public_subnets_cidr_block)
  vpc_config {

    subnet_ids = aws_subnet.public_subnets[*].id
  }

  # Ensure that IAM Role permissions are created before and deleted
  # after EKS Cluster handling. Otherwise, EKS will not be able to
  # properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.cluster_AmazonEKSClusterPolicy,
  ]
}

resource "aws_iam_role" "cluster" {
  name = "eks-cluster-example"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "sts:AssumeRole",
          "sts:TagSession"
        ]
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "cluster_AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.cluster.name
}


resource "aws_eks_node_group" "eks-nodegroup" {
  cluster_name    = aws_eks_cluster.eks-terraform.name
  node_group_name = "eks-nodegroup"
  node_role_arn   = aws_iam_role.eks-node-group-role.arn
  #   count           = length(var.public_subnets_cidr_block)
  subnet_ids = aws_subnet.public_subnets[*].id

  scaling_config {
    desired_size = 1
    max_size     = 2
    min_size     = 1
  }

  update_config {
    max_unavailable = 1
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.example-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.example-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.example-AmazonEC2ContainerRegistryReadOnly,
  ]
}

resource "aws_iam_role" "eks-node-group-role" {
  name = "eks-node-group-role"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "example-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks-node-group-role.name
}

resource "aws_iam_role_policy_attachment" "example-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks-node-group-role.name
}

resource "aws_iam_role_policy_attachment" "example-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks-node-group-role.name
}