output "role_arns" {
  value       = { for name, role in aws_iam_role.tier : name => role.arn }
  description = "Created role ARNs by access tier."
}

output "boundary_arn" {
  value       = aws_iam_policy.boundary.arn
  description = "Permissions boundary ARN applied to delegated operator roles."
}

