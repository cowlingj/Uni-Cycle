
# create the cluster, allow it to act as EKS service and wait for it to come online

resource "aws_iam_role" "primary-cluster" {
  name               = "terraform-eks-primary-cluster"
  assume_role_policy = data.aws_iam_policy_document.cluster.json
}

data "aws_iam_policy_document" "cluster" {
  statement {
    sid = "EKSClusterAssumeRole"

    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "primary-cluster-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.primary-cluster.name
}

resource "aws_iam_role_policy_attachment" "primary-cluster-AmazonEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.primary-cluster.name
}

resource "aws_eks_cluster" "primary" {
  name     = var.cluster_name
  role_arn = aws_iam_role.primary-cluster.arn

  vpc_config {
    security_group_ids = [aws_security_group.primary.id]
    subnet_ids         = aws_subnet.primary[*].id
  }

  version = "${var.kubernetes_version_major}.${var.kubernetes_version_minor}"

  depends_on = [
    aws_iam_role_policy_attachment.primary-cluster-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.primary-cluster-AmazonEKSServicePolicy,
  ]
}

resource null_resource wait_for_cluster {

  triggers = {
    cluster_endpoint = aws_eks_cluster.primary.endpoint
    cluster_nodes    = join("|", [aws_eks_node_group.primary.id])
  }

  provisioner local-exec {
    when    = create
    command = <<EOF
      for i in `seq 1 60`; do
        wget --no-check-certificate -O - -q ${self.triggers.cluster_endpoint}/healthz >/dev/null && exit 0
        sleep 5
      done
      
      echo TIMEOUT && exit 1
    EOF
  }
}