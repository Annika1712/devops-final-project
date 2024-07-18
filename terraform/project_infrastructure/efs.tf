resource "aws_efs_file_system" "mongodb" {
  creation_token = "${module.eks.cluster_name}-mongodb-dev"

  tags = {
    Name = "${module.eks.cluster_name}-mongodb-dev"
  }
}

resource "aws_efs_mount_target" "mongodb" {
  for_each = toset(module.vpc.private_subnets)
  file_system_id = aws_efs_file_system.mongodb.id
  subnet_id = module.vpc.private_subnets[index(module.vpc.private_subnets, each.key)]
  security_groups = [aws_security_group.efs_mount.id, module.vpc.default_security_group_id]

}

resource "aws_security_group" "efs_mount" {
  name        = "allow_efs"
  description = "Allow EFS inbound traffic and all outbound traffic"
  vpc_id      = module.vpc.vpc_id

  tags = {
    Name = "allow_efs"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_efs_ipv4" {
  security_group_id = aws_security_group.efs_mount.id
  cidr_ipv4         = module.vpc.vpc_cidr_block
  from_port         = 2049
  ip_protocol       = "tcp"
  to_port           = 2049
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.efs_mount.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

output "efs_file_system_id" {
  value = aws_efs_file_system.mongodb.id
}

resource "aws_security_group_rule" "NFS" {
  type              = "ingress"
  from_port         = 2049
  to_port           = 2049
  protocol          = "tcp"
  cidr_blocks       = [module.vpc.vpc_cidr_block]
  security_group_id = module.eks.node_security_group_id
  
}
