$ports = Get-NetTCPConnection -State Established | Select-Object -Property LocalAddress, LocalPort, RemoteAddress, RemotePort, OwningProcess

$openPorts = $ports | ForEach-Object {
    $processName = (Get-Process -Id $_.OwningProcess -ErrorAction SilentlyContinue).ProcessName
    if (-not [string]::IsNullOrEmpty($processName)) {
        [PSCustomObject]@{
            LocalAddress   = $_.LocalAddress
            LocalPort      = $_.LocalPort
            RemoteAddress  = $_.RemoteAddress
            RemotePort     = $_.RemotePort
            OwningProcess  = $_.OwningProcess
            ProcessName    = $processName
        }
    }
}

$openPorts | Format-Table -AutoSize
