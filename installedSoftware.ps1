$installedSoftware = Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | Select-Object DisplayName, DisplayVersion, Publisher, InstallDate | Where-Object { $_.DisplayName -ne $null } | Sort-Object DisplayName
$installedSoftware | Export-Csv -Path "InstalledSoftware.csv" -NoTypeInformation
