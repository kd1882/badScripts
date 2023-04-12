$results = @()

# Check V-220697: Windows 10 Enterprise Edition 64-bit version
$osEdition = (Get-CimInstance -ClassName Win32_OperatingSystem).Caption
$osArchitecture = (Get-CimInstance -ClassName Win32_OperatingSystem).OSArchitecture
$checkV220697 = @{
    ID = "V-220697"
    Result = "Pass"
    Description = "Domain-joined systems must use Windows 10 Enterprise Edition 64-bit version."
    STIG_Check = "Windows 10 Enterprise Edition 64-bit check"
}
if ($osEdition -notlike "*Windows 10 Enterprise*" -or $osArchitecture -ne "64-bit") {
    $checkV220697.Result = "Fail"
}
$results += $checkV220697

# Check V-220698: TPM enabled and ready for use
$tpm = Get-WmiObject -Namespace root\CIMV2\Security\MicrosoftTpm -Class Win32_Tpm
$checkV220698 = @{
    ID = "V-220698"
    Result = "Pass"
    Description = "Windows 10 domain-joined systems must have a Trusted Platform Module (TPM) enabled and ready for use."
    STIG_Check = "TPM enabled and ready for use check"
}
if ($tpm -eq $null -or $tpm.IsEnabled().IsEnabled -ne "True" -or -not($tpm.SpecVersion -contains "2.0" -or $tpm.SpecVersion -contains "1.2")) {
    $checkV220698.Result = "Fail"
}
$results += $checkV220698

# Check V-220699: UEFI mode enabled
$firmware = Get-WmiObject -Class Win32_ComputerSystem
$checkV220699 = @{
    ID = "V-220699"
    Result = "Pass"
    Description = "Windows 10 systems must have Unified Extensible Firmware Interface (UEFI) firmware and be configured to run in UEFI mode, not Legacy BIOS."
    STIG_Check = "UEFI mode enabled check"
}
if ($firmware.PCSystemType -ne 2) {
    $checkV220699.Result = "Fail"
}
$results += $checkV220699

# Check V-220700: Secure Boot enabled
$secureBoot = Get-WmiObject -Class Win32_DeviceGuard -Namespace root\Microsoft\Windows\DeviceGuard
$checkV220700 = @{
    ID = "V-220700"
    Result = "Pass"
    Description = "Secure Boot must be enabled on Windows 10 systems."
    STIG_Check = "Secure Boot enabled check"
}
if ($secureBoot.SecureBoot -ne 1) {
    $checkV220700.Result = "Fail"
}
$results += $checkV220700

# Export results to CSV
$results | Export-Csv -Path "stigChecks.csv" -NoTypeInformation
