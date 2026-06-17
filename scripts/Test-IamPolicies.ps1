param(
    [Parameter(Mandatory = $false)]
    [string]$PolicyPath = "./policies"
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

if (-not (Test-Path -LiteralPath $PolicyPath)) {
    throw "Policy path not found: $PolicyPath"
}

$issues = New-Object System.Collections.Generic.List[string]
$policyFiles = Get-ChildItem -LiteralPath $PolicyPath -Filter "*.json" -File

function Test-IsReadOnlyAction {
    param([Parameter(Mandatory = $true)][string]$Action)

    return $Action -match "^[^:]+:(Describe|Get|List|Lookup|Filter|GenerateCredentialReport)"
}

foreach ($file in $policyFiles) {
    $policy = Get-Content -LiteralPath $file.FullName -Raw | ConvertFrom-Json

    foreach ($statement in @($policy.Statement)) {
        $sid = if ($statement.PSObject.Properties.Name -contains "Sid") { $statement.Sid } else { "NoSid" }
        $actions = @($statement.Action)
        $resources = @($statement.Resource)
        $hasCondition = $statement.PSObject.Properties.Name -contains "Condition"
        $mutatingActions = @($actions | Where-Object { -not (Test-IsReadOnlyAction -Action $_) })

        if ($statement.Effect -eq "Allow" -and ($actions -contains "*" -or ($actions | Where-Object { $_ -match ":\*$" })) -and $mutatingActions.Count -gt 0) {
            $issues.Add("$($file.Name) [$sid] allows broad action: $($actions -join ', ')")
        }

        if ($statement.Effect -eq "Allow" -and $resources -contains "*" -and -not $hasCondition -and $mutatingActions.Count -gt 0) {
            $issues.Add("$($file.Name) [$sid] allows Resource=* without a condition")
        }

        if ($statement.Effect -eq "Allow" -and ($actions | Where-Object { $_ -match "^iam:(Attach|Put|Create|Update|Delete|PassRole)" })) {
            $issues.Add("$($file.Name) [$sid] allows sensitive IAM mutation")
        }
    }
}

if ($issues.Count -gt 0) {
    Write-Host "Policy review found issues:" -ForegroundColor Yellow
    $issues | ForEach-Object { Write-Host " - $_" -ForegroundColor Yellow }
    exit 1
}

Write-Host "Policy review passed for $($policyFiles.Count) policy file(s)." -ForegroundColor Green
