$RootDir = Resolve-Path $PSScriptRoot/..

. "$PSScriptRoot/install_module.ps1"

InstallModule "$RootDir/modules/base" "00_base"
InstallModule "$RootDir/modules/dev" "50_dev"
InstallModule "$RootDir/modules/colorscheme" "90_colorscheme"
