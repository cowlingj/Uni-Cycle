# create worker nodes and let them assume the role of EC2s

resource "aws_iam_role" "primary" {
  name               = "terraform-eks-primary"
  assume_role_policy = data.aws_iam_policy_document.workers.json
}

data "aws_iam_policy_document" "workers" {
  statement {
    sid = "EC2ClusterAssumeRole"

    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "primary_node_AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.primary.name
}

resource "aws_iam_role_policy_attachment" "primary_node_AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.primary.name
}

resource "aws_iam_role_policy_attachment" "primary_node_AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.primary.name
}

resource "aws_eks_node_group" "primary" {
  cluster_name    = aws_eks_cluster.primary.name
  node_group_name = "primary"
  node_role_arn   = aws_iam_role.primary.arn
  subnet_ids      = aws_subnet.primary[*].id

  scaling_config {
    desired_size = 1
    max_size     = 5
    min_size     = 1
  }

  instance_types = ["t2.small"]

  depends_on = [
    aws_iam_role_policy_attachment.primary_node_AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.primary_node_AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.primary_node_AmazonEC2ContainerRegistryReadOnly,
  ]

  lifecycle {
    ignore_changes = [scaling_config[0].desired_size]
  }
}

locals {
  mapNodeRoles = [
    {
      rolearn  = aws_iam_role.primary.arn
      username = "system:node:{{EC2PrivateDNSName}}"
      groups   = ["system:bootstrappers", "system:nodes"]
    }
  ]

  mapCallerUser = [
    {
      userarn  = data.aws_caller_identity.current.arn
      username = "${var.cluster_name}-creator"
      groups   = ["system:masters"]
    }
  ]
}
