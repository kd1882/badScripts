# Per the STIG Gods: Administrative accounts must not be used with applications that access the Internet, 
# such as web browsers, or with potential Internet sources, such as email.
# Need Daddy Shell 

# Function to check registry value
function Check-RegistryValue {
    param (
        [string]$Path,
        [string]$ValueName,
        [string]$ExpectedValue
    )

    try {
        $value = (Get-ItemProperty -Path $Path -Name $ValueName).$ValueName
        if ($value -eq $ExpectedValue) {
            return $true
        } else {
            return $false
        }
    } catch {
        return $false
    }
}

# Check NoDriveTypeAutoRun registry value
$registryPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\policies\Explorer"
$valueName = "NoDriveTypeAutoRun"
$expectedValue = 255

$registryCheckResult = Check-RegistryValue -Path $registryPath -ValueName $valueName -ExpectedValue $expectedValue

# Check Turn off AutoPlay policy value
$policyPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer"
$policyValueName = "NoAutoplayfornondrivenet"
$expectedPolicyValue = 1

$policyCheckResult = Check-RegistryValue -Path $policyPath -ValueName $policyValueName -ExpectedValue $expectedPolicyValue

# Display results
if ($registryCheckResult -and $policyCheckResult) {
    Write-Host "Both registry value and policy are configured correctly."
} elseif (-not $registryCheckResult -and -not $policyCheckResult) {
    Write-Host "Both registry value and policy are NOT configured correctly."
} else {
    if (-not $registryCheckResult) {
        Write-Host "Registry value is NOT configured correctly."
    }
    if (-not $policyCheckResult) {
        Write-Host "Policy is NOT configured correctly."
    }
}

# This script defines a function Check-RegistryValue to check the registry value. It then checks the 
# NoDriveTypeAutoRun registry value and the "Turn off AutoPlay" policy value. Based on the results, it 
# prints out whether the registry value and policy are configured correctly or not.
# Please note that this script only checks the configurations; it does not modify them.
