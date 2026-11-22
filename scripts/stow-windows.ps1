#Requires -Version 7.3

<#
.SYNOPSIS
Runs GNU Stow from MSYS2, defaulting to base-windows in the Windows home directory.
.DESCRIPTION
The target directory must already exist.
.EXAMPLE
./scripts/stow-windows.ps1 -WhatIf
.EXAMPLE
./scripts/stow-windows.ps1 -Action Restow
.EXAMPLE
./scripts/stow-windows.ps1 -Action Delete
#>
[CmdletBinding()]
param(
    [Parameter(Position = 0)]
    [string[]] $Package = @('base-windows'),
    [ValidateSet('Stow', 'Restow', 'Delete')]
    [string] $Action = 'Stow',
    [switch] $WhatIf,
    [string] $MsysRoot = 'C:\msys64',
    [string] $Target = $HOME,
    [string] $StowDirectory = (Join-Path (Split-Path -Parent $PSScriptRoot) 'stow'),
    [switch] $NoFolding
)

$ErrorActionPreference = 'Stop'
$PSNativeCommandUseErrorActionPreference = $false
$PSNativeCommandArgumentPassing = 'Standard'
$msysBin = Join-Path $MsysRoot 'usr/bin'
if (-not (Test-Path -LiteralPath "$msysBin/stow" -PathType Leaf)) {
    throw 'GNU Stow was not found. Run install-windows.ps1 or pass the installed MSYS2 directory with -MsysRoot.'
}

if (-not (Test-Path -LiteralPath $Target -PathType Container)) {
    throw "Stow target directory does not exist at $Target. Create it before running this script."
}

# Stow's Unix Perl needs POSIX paths even when launched directly from PowerShell.
$sourcePath = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($StowDirectory)
$targetPath = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($Target)
$paths = @(& "$msysBin/cygpath.exe" -au -- $sourcePath $targetPath)
if ($LASTEXITCODE -ne 0) {
    throw 'Could not convert the Stow source and target paths.'
}
$stowArgs = @("--dir=$($paths[0])", "--target=$($paths[1])", '--verbose=2')
if ($WhatIf) {
    $stowArgs += '--simulate'
}
if ($NoFolding) {
    $stowArgs += '--no-folding'
}
$stowArgs += "--$($Action.ToLowerInvariant())"

$previousMsys = $env:MSYS
try {
    $env:MSYS = 'winsymlinks:nativestrict'
    & "$msysBin/perl.exe" "$msysBin/stow" @stowArgs @Package
    if ($LASTEXITCODE -ne 0) {
        throw "GNU Stow failed with exit code $LASTEXITCODE. Review the Stow output above for the cause."
    }
} finally {
    $env:MSYS = $previousMsys
}
