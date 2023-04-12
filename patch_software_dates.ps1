# Checks patch dates for system and software
function Get-InstalledUpdates {
    $updates = Get-WmiObject -Class "win32_quickfixengineering" | Select-Object -Property "Description", "HotFixID", "InstalledOn"

    $outOfDateStatus = @()
    foreach ($update in $updates) {
        $installedOn = [datetime]::ParseExact($update.InstalledOn, 'yyyyMMdd', $null)
        $isOutOfDate = (Get-Date) - $installedOn -gt [timespan]::FromDays(30)

        $outOfDateStatus += [PSCustomObject]@{
            Description  = $update.Description
            HotFixID     = $update.HotFixID
            InstalledOn  = $installedOn
            IsOutOfDate  = $isOutOfDate
        }
    }

    return $outOfDateStatus
}

$results = Get-InstalledUpdates
$results | Export-Csv -Path "PatchStatus.csv" -NoTypeInformation
