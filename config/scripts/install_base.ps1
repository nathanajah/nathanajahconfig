$RootDir = Resolve-Path $PSScriptRoot/..

New-Item -path ~\AppData\Local\nvim -itemtype directory
New-Item -path ~\AppData\Local\nvim\lua\ -itemtype directory
New-Item -path ~\AppData\Local\nvim\lua\config -itemtype directory
New-Item -path ~\AppData\Local\nvim\lua\plugins -itemtype directory
New-Item -path ~\AppData\Local\nvim\init.lua -target $RootDir\configbase\vim\init.lua -itemtype SymbolicLink
New-Item -path ~\AppData\Local\nvim\lua\plugins\init.lua -target $RootDir\configbase\vim\lua\plugins\init.lua -itemtype SymbolicLink
New-Item -path ~\AppData\Local\nvim\lua\config\init.lua -target $RootDir\configbase\vim\lua\config\init.lua -itemtype SymbolicLink
New-Item -path ~\AppData\Local\nvim\ginit.vim -target $RootDir\configbase\vim\ginit.vim -itemtype SymbolicLink
