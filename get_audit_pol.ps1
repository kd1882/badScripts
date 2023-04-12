# Get Local Audit Policy settings
$auditCategories = @("System", "Logon/Logoff", "Object Access", "Privilege Use", "Detailed Tracking", "Policy Change", "Account Management", "Directory Service Access", "Account Logon")
$localAuditPolicy = auditpol.exe /get /category:* | Select-String -Pattern '^(.+)\s+(Success|Failure|Success and Failure|No Auditing)'
$localAuditResults = $localAuditPolicy | ForEach-Object {
    $auditCategory = $auditCategories[[int]($_.Line.Split()[0])]
    $auditSetting = $_.Line.Split()[1..($_.Line.Split().Length - 1)] -join ' '
    [PSCustomObject]@{
        Category = $auditCategory
        Setting  = $auditSetting
        Type     = "Local Audit Policy"
    }
}

# Get Advanced Audit Policy settings
$advancedAuditPolicy = auditpol.exe /get /category:* /r
$advancedAuditResults = $advancedAuditPolicy | ConvertFrom-Csv | ForEach-Object {
    [PSCustomObject]@{
        Category = $_.Subcategory
        Setting  = $_.InclusionSetting
        Type     = "Advanced Audit Policy"
    }
}

# Combine results and export to CSV
$auditResults = $localAuditResults + $advancedAuditResults
$auditResults | Export-Csv -Path "AuditRules.csv" -NoTypeInformation
