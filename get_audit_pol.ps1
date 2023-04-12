# Get Local Audit Policy settings
Write-Host "Local Audit Policy settings" -ForegroundColor Yellow
$auditCategories = @("System", "Logon/Logoff", "Object Access", "Privilege Use", "Detailed Tracking", "Policy Change", "Account Management", "Directory Service Access", "Account Logon")
$localAuditPolicy = auditpol.exe /get /category:* | Select-String -Pattern '^(.+)\s+(Success|Failure|Success and Failure|No Auditing)'
$localAuditPolicy | ForEach-Object {
    $auditCategory = $auditCategories[[int]($_.Line.Split()[0])]
    $auditSetting = $_.Line.Split()[1..($_.Line.Split().Length - 1)] -join ' '
    [PSCustomObject]@{
        Category = $auditCategory
        Setting  = $auditSetting
    }
} | Format-Table -AutoSize

# Get Advanced Audit Policy settings
Write-Host "`nAdvanced Audit Policy settings" -ForegroundColor Yellow
$advancedAuditPolicy = auditpol.exe /get /category:* /r
$advancedAuditPolicy | ConvertFrom-Csv | Format-Table -AutoSize
