terraform {
  required_version = ">= 1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

locals {
  policies = {
    readonly         = "${path.module}/../policies/tier-readonly.json"
    operator         = "${path.module}/../policies/tier-operator.json"
    security_auditor = "${path.module}/../policies/tier-security-auditor.json"
  }
}

resource "aws_iam_policy" "tier" {
  for_each = local.policies

  name        = "${var.name_prefix}-${replace(each.key, "_", "-")}"
  description = "Access lifecycle lab policy for ${each.key} tier."
  policy      = file(each.value)
}

resource "aws_iam_policy" "boundary" {
  name        = "${var.name_prefix}-delegated-admin-boundary"
  description = "Permissions boundary for delegated operator roles."
  policy      = file("${path.module}/../policies/boundary-delegated-admin.json")
}

resource "aws_iam_role" "tier" {
  for_each = local.policies

  name                 = "${var.name_prefix}-${replace(each.key, "_", "-")}"
  max_session_duration = var.max_session_duration
  permissions_boundary = each.key == "operator" ? aws_iam_policy.boundary.arn : null

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = var.trusted_principal_arn
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Project = "aws-iam-access-lifecycle"
    Tier    = each.key
  }
}

resource "aws_iam_role_policy_attachment" "tier" {
  for_each = local.policies

  role       = aws_iam_role.tier[each.key].name
  policy_arn = aws_iam_policy.tier[each.key].arn
}

