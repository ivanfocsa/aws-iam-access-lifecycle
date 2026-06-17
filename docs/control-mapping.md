# Control Mapping

| Control theme | Implementation in this repo | Evidence |
| --- | --- | --- |
| Least privilege | Tiered policies and scoped actions | Policy review output |
| Segregation of duties | Read, operate and audit roles separated | Role assignment matrix |
| Privileged access management | Emergency tier is time boxed | Approval and CloudTrail events |
| Change control | Terraform-managed roles and policies | Pull request and plan output |
| Continuous review | Access Analyzer and local checks | Analyzer findings export |
| Offboarding | Removal checklist | Access review ticket |

## Notes

The policies are intentionally conservative. They are starting points for a lab, not universal production policies.

