#Requires -Version 7.3

<#
.SYNOPSIS
Installs the Windows bootstrap packages, connects the PowerShell profile, and installs GNU Stow through MSYS2.
.EXAMPLE
./scripts/install-windows.ps1 -WhatIf
.EXAMPLE
./scripts/install-windows.ps1
#>
[CmdletBinding(SupportsShouldProcess)]
param(
    [string] $MsysRoot = 'C:\msys64'
)

$ErrorActionPreference = 'Stop'
$PSNativeCommandUseErrorActionPreference = $false
$PSNativeCommandArgumentPassing = 'Standard'

$packageFile = Join-Path (Split-Path -Parent $PSScriptRoot) 'packages/winget.txt'
$packageIds = @(
    Get-Content -LiteralPath $packageFile |
        ForEach-Object { ($_ -replace '#.*$').Trim() } |
        Where-Object { $_ } |
        Select-Object -Unique
)
if ($packageIds.Count -eq 0) {
    throw "No package IDs found in $packageFile."
}

$winget = $null
$failures = @()
$installedAny = $false
$noApplicableUpdate = 0x8A15002B

foreach ($packageId in $packageIds) {
    if (-not $PSCmdlet.ShouldProcess($packageId, 'Install missing package with WinGet')) {
        continue
    }

    if (-not $winget) {
        $winget = Get-Command winget.exe -CommandType Application -ErrorAction SilentlyContinue
        if (-not $winget) {
            throw 'WinGet (winget.exe) was not found. Install or update Microsoft App Installer, then open a new PowerShell session.'
        }
    }

    Write-Host "Installing $packageId..."
    $installArgs = @('install', '--id', $packageId, '--exact', '--source', 'winget', '--accept-source-agreements', '--no-upgrade')
    if ($packageId -eq 'MSYS2.MSYS2') {
        $installArgs += @('--location', $MsysRoot)
    }
    & $winget @installArgs
    $installExitCode = $LASTEXITCODE
    if ($installExitCode -eq 0) {
        $installedAny = $true
    } elseif ($installExitCode -eq $noApplicableUpdate) {
        Write-Host "$packageId is already installed."
    } else {
        $failures += "$packageId (install exit code $installExitCode)"
    }
}

if ($installedAny) {
    Write-Host 'Open a new PowerShell session to pick up PATH changes.'
}
if ($failures.Count -gt 0) {
    throw "WinGet failed for $($failures -join ', ')."
}

& (Join-Path $PSScriptRoot 'install-powershell-profile.ps1') -WhatIf:$WhatIfPreference

$bash = Join-Path $MsysRoot 'usr/bin/bash.exe'
$stow = Join-Path $MsysRoot 'usr/bin/stow'
if (-not $WhatIfPreference -and (Test-Path -LiteralPath $stow -PathType Leaf)) {
    Write-Host 'GNU Stow is already installed.'
    return
}
if ($PSCmdlet.ShouldProcess($MsysRoot, 'Initialize and update MSYS2, then install GNU Stow')) {
    if (-not (Test-Path -LiteralPath $bash -PathType Leaf)) {
        throw "MSYS2 Bash was not found at $bash. Pass the installed directory with -MsysRoot."
    }

    $previousMsystem = $env:MSYSTEM
    $previousChereInvoking = $env:CHERE_INVOKING
    try {
        $env:MSYSTEM = 'MSYS'
        $env:CHERE_INVOKING = '1'
        # Core updates can close Bash. A fresh process completes the full upgrade.
        foreach ($command in @('true', 'pacman --noconfirm -Syu', 'pacman --noconfirm -Syu', 'pacman --noconfirm -S --needed stow')) {
            & $bash -lc $command
            if ($LASTEXITCODE -ne 0) {
                throw "MSYS2 command '$command' exited with code $LASTEXITCODE. Rerun the bootstrap after resolving the reported error."
            }
        }
        & $bash -lc 'stow --version'
        if ($LASTEXITCODE -ne 0) {
            throw "GNU Stow verification failed with exit code $LASTEXITCODE."
        }
    } finally {
        $env:MSYSTEM = $previousMsystem
        $env:CHERE_INVOKING = $previousChereInvoking
    }
}
