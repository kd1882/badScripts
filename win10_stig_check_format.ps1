# This script performs a few checks, each containing a description and a script block for the check. 
# The script runs each check and outputs the results in a 'Pass' or 'Fail' format to a CSV file named 
# 'stigChecks.csv'. This example checks for three specific settings from the STIG, but you can expand the 
# $checks array to include more checks based on the STIG recommendations.
# Keep in mind that some checks may require administrative privileges to run.

# Define the checks
$checks = @(
    @{
        Description = "Ensure 'Microsoft network client: Digitally sign communications (always)' is set to 'Enabled'"
        Check = {
            $regPath = "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanWorkstation\Parameters"
            $value = Get-ItemProperty -Path $regPath -Name "RequireSecuritySignature" -ErrorAction SilentlyContinue
            return ($value.RequireSecuritySignature -eq 1)
        }
    },
    @{
        Description = "Ensure 'Interactive logon: Do not display last user name' is set to 'Enabled'"
        Check = {
            $regPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
            $value = Get-ItemProperty -Path $regPath -Name "DontDisplayLastUserName" -ErrorAction SilentlyContinue
            return ($value.DontDisplayLastUserName -eq 1)
        }
    },
    @{
        Description = "Ensure 'Interactive logon: Machine inactivity limit' is set to 900 seconds or less"
        Check = {
            $regPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
            $value = Get-ItemProperty -Path $regPath -Name "InactivityTimeoutSecs" -ErrorAction SilentlyContinue
            return ($value.InactivityTimeoutSecs -le 900)
        }
    }
)

# Run the checks
$results = $checks | ForEach-Object {
    $result = $_.Check.Invoke()
    [PSCustomObject]@{
        Description = $_.Description
        Result      = if ($result) { "Pass" } else { "Fail" }
    }
}

# Output the results to a CSV file
$results | Export-Csv -Path "stigChecks.csv" -NoTypeInformation
