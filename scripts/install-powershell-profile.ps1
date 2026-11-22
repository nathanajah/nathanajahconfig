#Requires -Version 7.3

<#
.SYNOPSIS
Connects the Stow-managed Windows profile to PowerShell's current-user, all-hosts profile.
.EXAMPLE
./scripts/install-powershell-profile.ps1 -WhatIf
.EXAMPLE
./scripts/install-powershell-profile.ps1
#>
[CmdletBinding(SupportsShouldProcess)]
param(
    [string] $ProfilePath = $PROFILE.CurrentUserAllHosts
)

$ErrorActionPreference = 'Stop'
$loader = 'if (Test-Path -LiteralPath "$HOME/.config/powershell/profile.ps1") { . "$HOME/.config/powershell/profile.ps1" }'

if (Test-Path -LiteralPath $ProfilePath) {
    $content = Get-Content -LiteralPath $ProfilePath -Raw
    if ($content -and $content.Contains($loader)) {
        Write-Host "PowerShell profile is already connected at $ProfilePath."
        return
    }
}

if ($PSCmdlet.ShouldProcess($ProfilePath, 'Append the Stow-managed profile loader')) {
    New-Item -ItemType Directory -Path (Split-Path -Parent $ProfilePath) -Force -Confirm:$false | Out-Null
    Add-Content -LiteralPath $ProfilePath -Value "`n# nathanajahconfig`n$loader`n" -Confirm:$false
    Write-Host "Connected the Windows profile at $ProfilePath."
}
