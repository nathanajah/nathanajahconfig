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

    $configRoot = $env:XDG_CONFIG_HOME
    if (-not $configRoot) {
        $configRoot = Join-Path $HOME '.config'
    }
    $configDirectory = $env:MISE_CONFIG_DIR
    if (-not $configDirectory) {
        $configDirectory = Join-Path $configRoot 'mise'
    }
    $previousFragment = Join-Path $configDirectory 'conf.d/nathanajahconfig.toml'
    if (Test-Path -LiteralPath $previousFragment -PathType Leaf) {
        # Retire the earlier installer artifact so it cannot override Stow's config.
        $windowsConfig = Join-Path (Split-Path -Parent $PSScriptRoot) 'stow/base-windows/.config/mise/config.toml'
        $deployedConfig = Join-Path $configDirectory 'config.toml'
        if (-not (Test-Path -LiteralPath $deployedConfig -PathType Leaf) -or
            (Get-FileHash -LiteralPath $deployedConfig).Hash -ne (Get-FileHash -LiteralPath $windowsConfig).Hash) {
            throw 'Deploy base-windows with stow-windows.ps1 before migrating the earlier fragment.'
        }
        if ((Get-FileHash -LiteralPath $previousFragment).Hash -ne (Get-FileHash -LiteralPath $windowsConfig).Hash) {
            throw "The earlier mise fragment at $previousFragment has different pins. Merge those into your Stow config and move the fragment aside before continuing."
        }
        $backup = "$previousFragment.$([guid]::NewGuid().ToString('N')).bak"
        Move-Item -LiteralPath $previousFragment -Destination $backup -Confirm:$false
        Write-Host "Saved the earlier mise fragment to $backup."
    }

    & $mise --cd $HOME install
    if ($LASTEXITCODE -ne 0) {
        throw "mise install failed with exit code $LASTEXITCODE."
    }
}
