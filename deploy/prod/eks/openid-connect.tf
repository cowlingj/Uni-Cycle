locals {
  oidc_issuer = aws_eks_cluster.primary.identity.0.oidc.0.issuer
}



resource "aws_iam_openid_connect_provider" "oidc" {
  url = local.oidc_issuer

  client_id_list = [
    "sts.amazonaws.com",
  ]

  thumbprint_list = [
    data.external.thumbprint.result.thumbprint
  ]
}

# https://medium.com/@marcincuber/amazon-eks-with-oidc-provider-iam-roles-for-kubernetes-services-accounts-59015d15cb0c
data "external" "thumbprint" {
  program = [
    "bash",
    "-c",
    <<EOF
get_thumbprint() {
  openssl s_client -servername oidc.eks.${data.aws_region.current.name}.amazonaws.com -showcerts -connect oidc.eks.${data.aws_region.current.name}.amazonaws.com:443 2>&- | \
  tac | \
  sed -n '/-----END CERTIFICATE-----/,/-----BEGIN CERTIFICATE-----/p; /-----BEGIN CERTIFICATE-----/q' | \
  tac | \
  openssl x509 -fingerprint -noout | \
  sed 's/://g' | \
  awk -F= '{print tolower($2)}'
}

echo { \"thumbprint\": \"$(get_thumbprint)\" }
EOF
  ]
}

