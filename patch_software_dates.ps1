# Function to check if a patch is out of date and punches it out to a csv
function Check-PatchStatus {
    param (
        [DateTime]$InstallDate
    )

    $daysSinceInstall = (Get-Date) - $InstallDate
    if ($daysSinceInstall.Days -gt 30) {
        return "Out of date"
    } else {
        return "Up to date"
    }
}

# Get installed updates
$installedUpdates = Get-HotFix | Select-Object -Property Description, HotFixID, InstalledOn, @{Name = "Status"; Expression = { Check-PatchStatus $_.InstalledOn }}

# Get installed software updates
$installedSoftware = Get-ChildItem -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall | Get-ItemProperty | Where-Object DisplayName -ne $null | Select-Object -Property DisplayName, DisplayVersion, InstallDate, @{Name = "Status"; Expression = { Check-PatchStatus (Get-Date $_.InstallDate) }}

# Combine results and export to CSV
$results = $installedUpdates + $installedSoftware
$results | Export-Csv -Path "PatchStatus.csv" -NoTypeInformation
