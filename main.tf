locals {
  issuer_url="https://container.googleapis.com/v1/projects/${var.cluster_project_id}/locations/${var.cluster_location}/clusters/${var.cluster_full_name}"
  issuer_hostpath="container.googleapis.com/v1/projects/${var.cluster_project_id}/locations/${var.cluster_location}/clusters/${var.cluster_full_name}"
}
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.14"
    }
  }
}

provider "aws" {
  region = var.aws_region
  profile = "saml"
}

resource "aws_iam_openid_connect_provider" "cra_identity_provider" {
  url= "${local.issuer_url}"
  thumbprint_list = ["${var.ca_thumbprint}"]
  client_id_list = ["${local.issuer_url}"]
}


resource "aws_iam_role" "cra_access_role" {
  name = "${var.aws_role_name}"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRoleWithWebIdentity"
        Effect = "Allow"
        Principal = {
          Federated = "${aws_iam_openid_connect_provider.cra_identity_provider.arn}"
        }
        Condition = {
          StringEquals = {
            "${local.issuer_hostpath}:sub": "system:serviceaccount:crossplane-system:cloud-resource-accelerator-provider-aws",          
          }
        }
      },
      {
        Action = "sts:AssumeRoleWithWebIdentity"
        Effect = "Allow"
        Principal = {
          Federated = "accounts.google.com"
        }
        Condition = {
          StringEquals = {
            "accounts.google.com:sub": "service-${var.cluster_project_number}@gcp-sa-gkemulticloud.iam.gserviceaccount.com"
          }
        }
      }

    ]
  })
}

resource "aws_iam_policy" "cra_access_policy" {
  name = "${var.aws_policy_name}"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
        "iam:*",
				"kms:*",
				"ec2:*",
				"elasticloadbalancing:*",
				"autoscaling:*",
				"eks:*"
        ],
        Effect = "Allow",
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "cra_attachment" {
  role = "${aws_iam_role.cra_access_role.name}"
  policy_arn = "${aws_iam_policy.cra_access_policy.arn}"
}