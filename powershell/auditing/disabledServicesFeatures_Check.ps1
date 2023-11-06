<#
.SYNOPSIS
    This script checks for disabled services and features on either Server2019 or Win10.

.DESCRIPTION
    This script contains two functions, CheckServices and CheckFeatures, that check for disabled services and features on either Server2019 or Win10. The user is prompted to select the platform they are running on, and the appropriate checks are performed based on their selection.

.PARAMETER servicesToCheck
    A hashtable containing the services to check for each platform. The keys are the platform selections (1 for Server2019, 2 for Win10), and the values are arrays of service names.

.PARAMETER featuresToCheck
    A hashtable containing the features to check for each platform. The keys are the platform selections (1 for Server2019, 2 for Win10), and the values are arrays of feature names.

.EXAMPLE
    PS C:\> .\disabledServicesFeatures_Check.ps1
    Select the platform you're running on: [1] Server2019 [2] Win10
    1
    Checking for Server2019 services and features that should be disabled...

    Service Name                Is Disabled Current Status
    ------------                ----------- --------------
    AppXSvc                     True        Stopped
    BDESVC                      True        Stopped
    BFE                         True        Stopped
    BITS                        True        Stopped
    Browser                     True        Stopped
    ...
    Feature Name                Is Installed
    ------------                ------------
    SMB1Protocol                False
    SMB1Protocol-Client         False
    SMB1Protocol-Server         False
    SMBv1Direct                 False
    SMBv1Protocol               False
    SMBv2Protocol               True
    SMBv3Protocol               True

.NOTES
    Author: Ken DAvis
#>
function CheckServices($servicesToCheck) {
    $results = @()
    foreach ($service in $servicesToCheck) {
        $serviceObj = New-Object PSObject -Property @{
            'Service Name'   = $service
            'Is Disabled'    = $null
            'Current Status' = $null
        }

        $serviceStatus = Get-Service -DisplayName $service -ErrorAction SilentlyContinue

        if ($serviceStatus) {
            $serviceStartType = (Get-WmiObject -Query "SELECT StartMode FROM Win32_Service WHERE DisplayName = '$service'").StartMode
            $serviceObj.'Is Disabled' = $serviceStartType -eq 'Disabled'
            $serviceObj.'Current Status' = $serviceStatus.Status
        }
        else {
            $serviceObj.'Is Disabled' = "Not Found"
            $serviceObj.'Current Status' = "Not Found"
        }

        $results += $serviceObj
    }
    return $results
}

function CheckFeatures($featuresToCheck, $isServer2019) {
    $results = @()
    foreach ($feature in $featuresToCheck) {
        if ($isServer2019) {
            $featureObj = New-Object PSObject -Property @{
                'Feature Name' = $feature
                'Is Installed' = $null
            }

            $featureStatus = Get-WindowsFeature -Name $feature -ErrorAction SilentlyContinue

            if ($featureStatus) {
                $featureObj.'Is Installed' = $featureStatus.InstallState -eq "Installed"
            }
            else {
                $featureObj.'Is Installed' = "Not Found"
            }

            $results += $featureObj
        }
        else {
            $featureStatus = Get-WindowsOptionalFeature -Online -FeatureName $feature

            $results += [PSCustomObject]@{
                'Feature Name' = $feature
                'Is Disabled'  = $featureStatus.State -eq "Disabled"
            }
        }
    }
    return $results
}


$selection = Read-Host "Select the platform you're running on: [1] Server2019 [2] Win10"

$servicesToCheck = @{
    '1' = @(
       
    )
    '2' = @(
        
    )
}

$featuresToCheck = @{
    '1' = @(
      
    )
    '2' = @(
      
    )
}

switch ($selection) {
    '1' {
        Write-Host "Checking for Server2019 services and features that should be disabled..."
        $serviceResults = CheckServices $servicesToCheck['1']
        $featureResults = CheckFeatures $featuresToCheck['1'] $true

        $serviceResults | Format-Table 'Service Name', 'Is Disabled', 'Current Status' -AutoSize
        $featureResults | Format-Table 'Feature Name', 'Is Installed' -AutoSize
    }
    '2' {
        Write-Host "Checking for Win10 services and features that should be disabled..."
        $serviceResults = CheckServices $servicesToCheck['2']
        $featureResults = CheckFeatures $featuresToCheck['2'] $false

        $serviceResults | Format-Table 'Service Name', 'Is Disabled', 'Current Status' -AutoSize
        $featureResults | Format-Table 'Feature Name', 'Is Disabled' -AutoSize
    }
    default {
        Write-Host "Invalid selection. Please choose either '1' for Server2019 or '2' for Win10."
    }
}
