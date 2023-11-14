function Main() {
    [CmdletBinding()]
    param (
        [Parameter(Position = 0)]
        [ValidateSet('CLI', 'GUI')]
        [String] $Mode = 'GUI'
    )

    Begin {
        $Script:NeedRestart = $false
        $Script:DoneTitle = "Information"
        $Script:DoneMessage = "Process Completed!"
    }

    Process {
        Clear-Host
        Request-AdminPrivilege
        Get-ChildItem -Recurse $PSScriptRoot\*.ps*1 | Unblock-File
        
        Import-Module -DisableNameChecking "$PSScriptRoot\src\lib\Get-HardwareInfo.psm1" -Force
        Import-Module -DisableNameChecking "$PSScriptRoot\src\lib\Open-File.psm1" -Force
        Import-Module -DisableNameChecking "$PSScriptRoot\src\lib\Set-ConsoleStyle.psm1" -Force
        Import-Module -DisableNameChecking "$PSScriptRoot\src\lib\Set-RevertStatus.psm1" -Force
        Import-Module -DisableNameChecking "$PSScriptRoot\src\lib\Start-Logging.psm1" -Force
        Import-Module -DisableNameChecking "$PSScriptRoot\src\lib\Title-Templates.psm1" -Force
        Import-Module -DisableNameChecking "$PSScriptRoot\src\lib\ui\Get-CurrentResolution.psm1" -Force
        Import-Module -DisableNameChecking "$PSScriptRoot\src\lib\ui\Get-DefaultColor.psm1" -Force
        Import-Module -DisableNameChecking "$PSScriptRoot\src\lib\ui\New-LayoutPage.psm1" -Force
        Import-Module -DisableNameChecking "$PSScriptRoot\src\lib\ui\Show-MessageDialog.psm1" -Force
        Import-Module -DisableNameChecking "$PSScriptRoot\src\lib\ui\Ui-Helper.psm1" -Force


        If ("$pwd" -notlike "$PSScriptRoot") {
            Write-Host "Wrong location detected, changing to script folder!" -BackgroundColor Yellow
            Set-Location -Path "$PSScriptRoot"
        }

        Set-ConsoleStyle
        $CurrentFileName = (Split-Path -Path $PSCommandPath -Leaf).Split('.')[0]
        $CurrentFileLastModified = (Get-Item "$(Split-Path -Path $PSCommandPath -Leaf)").LastWriteTimeUtc | Get-Date -Format "yyyy-MM-dd"
        (Get-Item "$(Split-Path -Path $PSCommandPath -Leaf)").LastWriteTimeUtc | Get-Date -Format "yyyy-MM-dd"
        Start-Logging -File "$CurrentFileName-$(Get-Date -Format "yyyy-MM")"
        Write-Caption "$CurrentFileName v$CurrentFileLastModified"
        Write-Host "Your Current Folder $pwd"
        Write-Host "Script Root Folder $PSScriptRoot"
        Write-ScriptLogo

        If ($args) {
            Write-Caption "Arguments: $args"
        } Else { Write-Caption "Arguments: None, running GUI" }

        If ($Mode -eq 'CLI') {
            Open-AuditBox -Mode $Mode
        } Else { Show-GUI }
    }

    End {
        Write-Verbose "Restart: $Script:NeedRestart"
        If ($Script:NeedRestart) {
            Request-PcRestart
        }
        Stop-Logging
    }
}

function Open-AuditBox {
    [CmdletBinding()]
    param(
        [Parameter(Position = 0)]
        [ValidateSet('CLI', 'GUI')]
        [String] $Mode = 'GUI'
    )

    $Scripts = @(
        # [Recommended order]
        # "Backup-System.ps1",
        # "Use-DebloatSoftware.ps1",
        # "Optimize-TaskScheduler.ps1",
        # "Optimize-ServicesRunning.ps1",
        # "Remove-BloatwareAppsList.ps1",
        # "Optimize-Privacy.ps1",
        # "Optimize-Performance.ps1",
        # "Register-PersonalTweaksList.ps1",
        # "Optimize-Security.ps1",
        # "Remove-CapabilitiesList.ps1",
        # "Optimize-WindowsFeaturesList.ps1"
    )

    If ($Mode -eq 'CLI') {
        Open-PowerShellFilesCollection -RelativeLocation "src\scripts" -Scripts $Scripts -DoneTitle $DoneTitle -DoneMessage $DoneMessage -OpenFromGUI $false
    } ElseIf ($Mode -eq 'GUI') {
        Open-PowerShellFilesCollection -RelativeLocation "src\scripts" -Scripts $Scripts -DoneTitle $DoneTitle -DoneMessage $DoneMessage
    }

    $Script:NeedRestart = $true
}

# function Request-AdminPrivilege() {
#     # Used from https://stackoverflow.com/a/31602095 because it preserves the working directory!
#     If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
#         Start-Process -Verb RunAs -FilePath powershell.exe -ArgumentList "-NoProfile", "-ExecutionPolicy Bypass", "-File `"$PSCommandPath`""; exit
#     }
# }

function Request-AdminPrivilege() {
    # Used from https://stackoverflow.com/a/31602095 because it preserves the working directory!
    If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
        Try {
            winget --version
            Start-Process -Verb RunAs -FilePath "wt.exe" -ArgumentList "--startingDirectory `"$PSScriptRoot`" --profile `"Windows PowerShell`"", "cmd /c powershell.exe -NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`""; taskkill.exe /f /im $PID; exit
        } Catch {
            Start-Process -Verb RunAs -FilePath powershell.exe -ArgumentList "-NoProfile", "-ExecutionPolicy Bypass", "-File `"$PSCommandPath`""; exit
        }
    }
}

function Show-GUI() {
    Write-Status -Types "@", "UI" -Status "Loading GUI Layout..."
    Add-Type -AssemblyName System.Windows.Forms
    Add-Type -AssemblyName System.Drawing
    [System.Windows.Forms.Application]::EnableVisualStyles()
    $form = New-Object System.Windows.Forms.Form
    $form.Text = 'AuditBox'
    $form.Size = New-Object System.Drawing.Size(900, 600)
    $form.StartPosition = 'CenterScreen'


}



If ($args) {
    Main -Mode $args[0]
} Else {
    Main
}


$form = New-Object System.Windows.Forms.Form
$form.Text = 'Simple GUI'
$form.Size = New-Object System.Drawing.Size(300, 200)
$form.StartPosition = 'CenterScreen'

$label = New-Object System.Windows.Forms.Label
$label.Location = New-Object System.Drawing.Point(10, 20)
$label.Size = New-Object System.Drawing.Size(280, 20)
$label.Text = 'Enter something:'
$form.Controls.Add($label)

$textBox = New-Object System.Windows.Forms.TextBox
$textBox.Location = New-Object System.Drawing.Point(10, 40)
$textBox.Size = New-Object System.Drawing.Size(260, 20)
$form.Controls.Add($textBox)

$button = New-Object System.Windows.Forms.Button
$button.Location = New-Object System.Drawing.Point(10, 70)
$button.Size = New-Object System.Drawing.Size(100, 20)
$button.Text = 'Click me'
$button.Add_Click({
        $msg = $textBox.Text
        [System.Windows.Forms.MessageBox]::Show("You entered: $msg")
    })
$form.Controls.Add($button)

$form.ShowDialog()