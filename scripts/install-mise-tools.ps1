#Requires -Version 7.0

<#
.SYNOPSIS
Installs tools from the active mise configuration in the home directory.
.DESCRIPTION
Deploy base-windows with stow-windows.ps1 before running this script.
.EXAMPLE
./scripts/install-mise-tools.ps1 -WhatIf
.EXAMPLE
./scripts/stow-windows.ps1
./scripts/install-mise-tools.ps1
#>
[CmdletBinding(SupportsShouldProcess)]
param()

$ErrorActionPreference = 'Stop'
$PSNativeCommandUseErrorActionPreference = $false

if ($PSCmdlet.ShouldProcess($HOME, 'Install tools from the active mise configuration')) {
    $mise = Get-Command mise.exe -CommandType Application -ErrorAction SilentlyContinue
    if (-not $mise) {
        throw 'mise.exe was not found. Run install-windows.ps1, then open a new PowerShell session.'
    }

    & $mise --cd $HOME install
    if ($LASTEXITCODE -ne 0) {
        throw "mise install failed with exit code $LASTEXITCODE."
    }
}
