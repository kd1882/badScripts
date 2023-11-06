<#
.SYNOPSIS
    This script checks the last logon date for a list of users and determines if it was within the last 6 months.

.DESCRIPTION
    This script loops through a list of user names and retrieves the last logon date for each user. It then compares the last logon date to the current date minus 6 months to determine if the user has logged on within the last 6 months.

.PARAMETER userNames
    An array of user names to check.

.EXAMPLE
    PS C:\> .\userLast_domain.ps1
    Administrator last logged on more than 6 months ago.
    DefaultAccount last logged on more than 6 months ago.
    Guest last logged on more than 6 months ago.
    WDAGUtilityAccount last logged on more than 6 months ago.
    WinTest last logged on within the last 6 months.

.NOTES
    Author: Ken Davis
    Date: 11/05/2023
    Version: 1.0
#>

$userNames = @(
    "Administrator",
    "DefaultAccount",
    "Guest",
    "WDAGUtilityAccount",
    "WinTest"
)

# Get current date and subtract 6 months
$sixMonthsAgo = (Get-Date).AddMonths(-6)

# Loop through each user and perform the check
foreach ($userName in $userNames) {
    try {
        # Get the last logon details for the user
        $lastLogonDetails = net user $userName | Select-String -Pattern "Last logon"
        $dateTimeString = $lastLogonDetails -replace "^Last logon\s+", ""
        $dateTime = [DateTime]::Parse($dateTimeString)

        # Check if the last logon date is more recent than six months ago
        if ($dateTime -gt $sixMonthsAgo) {
            Write-Host "$userName last logged on within the last 6 months."
        } else {
            Write-Host "$userName last logged on more than 6 months ago."
        }
    } catch [System.FormatException] {
        Write-Warning "Unable to parse date for user $userName. The user may never have logged on or the date format was not recognized."
    } catch {
        Write-Warning "An unexpected error occurred while processing user $userName : $_"
    }
}
