$localUsers = Get-LocalUser | Select-Object Name, Enabled, AccountExpires, LastLogon, PasswordLastSet, PasswordChangeableDate, UserPrincipalName
$localUsers | Export-Csv -Path "LocalUsers.csv" -NoTypeInformation
