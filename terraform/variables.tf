variable "name_prefix" {
  type        = string
  description = "Prefix used for IAM lab resources."
  default     = "iam-lifecycle"
}

variable "trusted_principal_arn" {
  type        = string
  description = "Federated role or account principal allowed to assume lab roles."
}

variable "max_session_duration" {
  type        = number
  description = "Maximum session duration for lab roles in seconds."
  default     = 3600
}

