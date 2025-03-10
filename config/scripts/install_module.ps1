function InstallModule($ModulePath, $InstallAs)
{
  New-Item -path ~\AppData\Local\nvim\lua\plugins\$InstallAs -target $ModulePath\vim\lua\plugins -itemtype SymbolicLink
  New-Item -path ~\AppData\Local\nvim\lua\config\$InstallAs -target $ModulePath\vim\lua\config -itemtype SymbolicLink
}
