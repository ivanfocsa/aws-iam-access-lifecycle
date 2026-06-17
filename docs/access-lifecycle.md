# Access Lifecycle

## 1. Request

Every access request must include:

- business justification;
- target AWS account;
- requested tier;
- expected duration;
- approver.

## 2. Tier assignment

| Tier | Purpose | Typical duration | Review |
| --- | --- | --- | --- |
| ReadOnly | Inventory and troubleshooting | 90 days | Quarterly |
| Operator | Scoped changes on approved services | 30 days | Monthly |
| SecurityAuditor | Evidence collection and control review | 90 days | Quarterly |
| Emergency | Incident response | Less than 8 hours | After-action review |

## 3. Enforcement

- Human access should come from an identity provider or IAM Identity Center.
- Long-lived IAM users are out of scope except for documented break-glass cases.
- Operator roles should be protected by a permissions boundary.
- Privileged access should be time-boxed and logged.

## 4. Review

Review evidence should include:

- assigned principal;
- attached policies;
- last activity;
- Access Analyzer findings;
- CloudTrail activity during the review period.

## 5. Offboarding

- Remove group assignment or role mapping.
- Disable active sessions where supported.
- Check recent CloudTrail events for unusual activity.
- Keep evidence in the access review folder.

