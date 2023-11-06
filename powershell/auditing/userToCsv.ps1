<#
.SYNOPSIS
This script retrieves all users from the domain and exports them to a CSV file.

.DESCRIPTION
The script uses the 'net user' command to retrieve all users from the domain. It then filters out any lines that are not usernames and creates a list of custom objects with the username property for each user. Finally, it exports the list to a CSV file.

.PARAMETER FilePath
Specifies the path of the script.

.EXAMPLE
PS C:\> .\userToCsv.ps1
This will retrieve all users from the domain and export them to a CSV file located at 'C:\Users\WinTest\Documents\test.csv'.

.NOTES
Author: Ken Davis
Date: 11/05/2023
Version: 1.0
#>

# Get all users from the domain, exclude lines that are not usernames
$usersRaw = net user | Where-Object {
    $_ -and
    $_ -notmatch "command completed successfully" -and
    $_ -notmatch "User accounts for" -and
    $_ -notmatch "-----" -and
    $_ -notmatch "The command completed"
}

# Split the output into individual user names and trim any whitespace
$users = $usersRaw -split '\s+' | Where-Object { $_ -and $_ -notmatch "The command completed" }

# Create a list of custom objects with the username property for each user
$userObjects = $users | ForEach-Object {
    [PSCustomObject]@{
        UserName = $_
    }
}

# Export to CSV
$userObjects | Export-Csv -Path 'C:\Users\WinTest\Documents\test.csv' -NoTypeInformation
