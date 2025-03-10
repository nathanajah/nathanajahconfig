#!/bin/bash

set -euxo pipefail

# Check if the apps are installed
# If not, exit
# Apps to be checked: git, g++, gcc, fzf
cppapps=("g++" "gcc" "ctags")
utils=("git" "fzf" "ranger" "tmux" "zsh" "curl" "rsync" "ranger")
goapps=("go" "gopls")
pythonapps=("python3" "pip")
nvimapps=("nvim")

all_apps=("${cppapps[@]}" "${utils[@]}" "${goapps[@]}" "${nvimapps[@]}" "${pythonapps[@]}")

for app in "${all_apps[@]}"; do
    if ! command -v "$app" &> /dev/null; then
        echo "$app is not installed."
        exit 1
    fi
done

