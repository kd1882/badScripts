$systemInfo = Get-CimInstance -ClassName Win32_ComputerSystem | Select-Object Name, Domain, Model, Manufacturer, SystemType, NumberOfProcessors, TotalPhysicalMemory, UserName, DomainRole
$osInfo = Get-CimInstance -ClassName Win32_OperatingSystem | Select-Object Caption, Version, BuildNumber, OSArchitecture, SystemDirectory, WindowsDirectory
$diskInfo = Get-CimInstance -ClassName Win32_LogicalDisk | Where-Object { $_.DriveType -eq 3 } | Select-Object DeviceID, FileSystem, FreeSpace, Size

$info = [PSCustomObject]@{
    ComputerName = $systemInfo.Name
    Domain = $systemInfo.Domain
    Model = $systemInfo.Model
    Manufacturer = $systemInfo.Manufacturer
    SystemType = $systemInfo.SystemType
    NumberOfProcessors = $systemInfo.NumberOfProcessors
    TotalPhysicalMemory = $systemInfo.TotalPhysicalMemory
    UserName = $systemInfo.UserName
    DomainRole = $systemInfo.DomainRole
    OSCaption = $osInfo.Caption
    OSVersion = $osInfo.Version
    BuildNumber = $osInfo.BuildNumber
    OSArchitecture = $osInfo.OSArchitecture
    SystemDirectory = $osInfo.SystemDirectory
    WindowsDirectory = $osInfo.WindowsDirectory
    DiskInfo = $diskInfo
}

$info | Export-Csv -Path "SystemInfo.csv" -NoTypeInformation
