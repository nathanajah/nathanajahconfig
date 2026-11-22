$env:EDITOR = 'nvim'
$env:VISUAL = 'nvim'
$env:STARSHIP_CONFIG = Join-Path $HOME '.config/starship.toml'
$env:ZELLIJ_CONFIG_DIR = Join-Path $env:APPDATA 'Zellij/config'

if (Get-Module PSReadLine) {
    Set-PSReadLineOption -EditMode Vi
    Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
    Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
}

if (Get-Command mise -ErrorAction SilentlyContinue) {
    # Make managed binaries available before initializing the prompt and navigation.
    (& mise env --shell pwsh) | Out-String | Invoke-Expression
}

if (Get-Command zoxide -ErrorAction SilentlyContinue) {
    (& zoxide init powershell) | Out-String | Invoke-Expression
}

if (Get-Command starship -ErrorAction SilentlyContinue) {
    (& starship init powershell) | Out-String | Invoke-Expression
}

if (Get-Command mise -ErrorAction SilentlyContinue) {
    # Wrap Starship's prompt so tool versions also refresh before each prompt.
    (& mise activate pwsh) | Out-String | Invoke-Expression
}
