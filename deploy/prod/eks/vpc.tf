# vpc with subnets, routing, and gateways
# this is necessary for interacting with the cluster nodes

resource "aws_vpc" "primary" {
  cidr_block = "10.0.0.0/16"

  tags = map(
    "Name", "terraform-eks-primary-node",
    "kubernetes.io/cluster/${var.cluster_name}", "shared",
  )
}

resource "aws_subnet" "primary" {
  count = 2

  availability_zone       = data.aws_availability_zones.available.names[count.index]
  cidr_block              = "10.0.${count.index}.0/24"
  map_public_ip_on_launch = true
  vpc_id                  = aws_vpc.primary.id

  tags = map(
    "Name", "terraform-eks-primary-node",
    "kubernetes.io/cluster/${var.cluster_name}", "shared",
  )
}

resource "aws_internet_gateway" "primary" {
  vpc_id = aws_vpc.primary.id

  tags = {
    Name = "terraform-eks-primary"
  }
}

resource "aws_route_table" "primary" {
  vpc_id = aws_vpc.primary.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.primary.id
  }
}

resource "aws_route_table_association" "primary" {
  count = 2

  subnet_id      = aws_subnet.primary.*.id[count.index]
  route_table_id = aws_route_table.primary.id
}

resource "aws_security_group" "primary" {
  name        = "terraform-eks-primary-cluster"
  description = "Cluster communication with worker nodes"
  vpc_id      = aws_vpc.primary.id

  tags = {
    Name = "terraform-eks-primary"
  }
}

resource "aws_security_group_rule" "primary_nodes" {
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Cluster communication with worker nodes"
  from_port         = 0
  protocol          = "-1"
  security_group_id = aws_security_group.primary.id
  to_port           = 0
  type              = "egress"
}

resource "aws_security_group_rule" "primary_ingress_https" {
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Allow communication with the cluster API Server"
  from_port         = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.primary.id
  to_port           = 443
  type              = "ingress"
}
