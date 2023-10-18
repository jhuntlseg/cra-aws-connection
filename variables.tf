
variable "cluster_project_id" {
  description = "Project ID of the Management Cluster"
  type = string
  default = "crossplane-poc-394713"
}

variable "cluster_project_number" {
  description = "Project Number of the Management Cluster"
  type = string
  default = "863388703217"
}

variable "cluster_location" {
  description = "Location of the Management Cluster within GCP"
  type = string
  default = "europe-west1"
}

variable "cluster_full_name" {
  description = "Full name of the Management Cluster e.g. krmapihost-"
  type = string
  default = "krmapihost-management-cluster"
}

variable "ca_thumbprint" {
  description = "Certificate Thumbprint for the OIDC (container.googleapis.com)"
  type = string
  default = "08745487e891c19e3078c1f2a07e452950ef36f6"
}


variable "aws_region" {
  description = "AWS region"
  type = string
  default = "eu-west-2"
}

variable "aws_role_name" {
  description = "AWS instance name"
  type = string
  default = "cra-access-role"
}

variable "aws_policy_name" {
  description = "AWS instance name"
  type = string
  default = "cra-access-policy"
}