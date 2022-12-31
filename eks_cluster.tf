resource "aws_eks_cluster" "my_cluster" {
  name     = "my-cluster"
  role_arn = "${aws_iam_role.eks_cluster.arn}"

  vpc_config {
    security_group_ids = ["${aws_security_group.eks_cluster.id}"]
    subnet_ids        = ["${aws_subnet.eks_cluster.*.id}"]
  }
}

resource "aws_iam_role" "eks_cluster" {
  name = "eks-cluster"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_security_group" "eks_cluster" {
  name   = "eks-cluster"
  vpc_id = "${aws_vpc.eks_vpc.id}"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_vpc" "eks_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "eks-vpc"
  }
}

resource "aws_subnet" "eks_cluster" {
  count             = 2
  vpc_id            = "${aws_vpc.eks_vpc.id}"
  cidr_block        = "${cidrsubnet(aws_vpc.eks_vpc.cidr_block, 8, count.index)}"
  availability_zone = "${data.aws_availability_zones.available.names[count.index]}"

  tags = {
    Name = "eks-subnet-${count.index}"
  }
}