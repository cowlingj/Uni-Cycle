 
# enable autoscaling using the helm chart
# the chart needs IAM permissions using OpenID Connect and iam roles for service accounts
# see: https://www.terraform.io/docs/providers/aws/r/eks_cluster.html
# see: https://github.com/terraform-aws-modules/terraform-aws-iam/tree/master/modules/iam-assumable-role-with-oidc

locals {
  service_account_name = "autoscaler-sa"
}

data "aws_iam_policy_document" "assume_role_with_oidc" {

  statement {
    effect = "Allow"

    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type = "Federated"

      identifiers = [
        aws_iam_openid_connect_provider.oidc.arn
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "${replace(local.oidc_issuer, "https://", "")}:sub"
      values   = ["system:serviceaccount:${kubernetes_namespace.autoscaling.metadata[0].name}:${local.service_account_name}"]
    }
  }
}

resource "aws_iam_role" "cluster_autoscaler" {
  name                 = "cluster-autoscaler"
  assume_role_policy = data.aws_iam_policy_document.assume_role_with_oidc.json
}

resource "aws_iam_role_policy_attachment" "cluster_autoscaler" {
  role       = aws_iam_role.cluster_autoscaler.name
  policy_arn = aws_iam_policy.cluster_autoscaler.arn
}

resource "aws_iam_policy" "cluster_autoscaler" {
  name_prefix = "cluster-autoscaler"
  policy      = data.aws_iam_policy_document.cluster_autoscaler.json
}

data "aws_iam_policy_document" "cluster_autoscaler" {
  statement {
    sid    = "clusterAutoscalerAll"
    effect = "Allow"

    actions = [
      "autoscaling:DescribeAutoScalingGroups",
      "autoscaling:DescribeAutoScalingInstances",
      "autoscaling:DescribeLaunchConfigurations",
      "autoscaling:DescribeTags",
      "autoscaling:SetDesiredCapacity",
      "ec2:DescribeLaunchTemplateVersions",
    ]

    resources = ["*"]
  }
}

resource kubernetes_namespace autoscaling {
  metadata {
    generate_name = "autoscaling-"
  }
}

resource "helm_release" "autoscaler" {
  name       = "auto-scaler"
  chart      = "cluster-autoscaler"
  namespace  = kubernetes_namespace.autoscaling.metadata[0].name
  repository = "stable"

  depends_on = [
    aws_iam_role.cluster_autoscaler
  ]

  dynamic set {
    for_each = aws_eks_node_group.primary.resources.0.autoscaling_groups.*.name
    iterator = name
    content {
      name = "autoscalingGroups[${name.key}].name"
      value = name.value
    }
  }

  dynamic set {
    for_each = aws_eks_node_group.primary.resources.0.autoscaling_groups.*.name
    iterator = name
    content {
      name = "autoscalingGroups[${name.key}].maxSize"
      value = aws_eks_node_group.primary.scaling_config[name.key].max_size
    }
  }

  dynamic set {
    for_each = aws_eks_node_group.primary.resources.0.autoscaling_groups.*.name
    iterator = name
    content {
      name = "autoscalingGroups[${name.key}].minSize"
      value = aws_eks_node_group.primary.scaling_config[name.key].min_size
    }
  }

  set {
    name = "rbac.serviceAccountAnnotations.eks\\.amazonaws\\.com/role-arn"
    value = aws_iam_role.cluster_autoscaler.arn
  }

  set {
    name = "rbac.create"
    value = true
  }
  set {
    name = "rbac.serviceAccount.create"
    value = true
  }

  set {
    name = "rbac.serviceAccount.name"
    value = local.service_account_name
  }

  set {
    name = "kubeTargetVersionOverride"
    value = "1.16"
  }

  set {
    name = "image.tag"
    value = "v${var.kubernetes_version_major}.${var.kubernetes_version_minor}.${var.kubernetes_version_patch}"
  }

  set {
    name = "awsRegion"
    value = data.aws_region.current.name
  }
}