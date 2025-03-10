#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

mkdir -p ~/.config/nvim/lua/plugins
mkdir -p ~/.config/nvim/lua/config
mkdir -p ~/.config/git
ln -nsf "$SCRIPT_DIR/../configbase/zsh/.zshrc" ~/.zshrc
ln -nsf "$SCRIPT_DIR/../configbase/vim/init.lua" ~/.config/nvim/init.lua
ln -nsf "$SCRIPT_DIR/../configbase/vim/lua/plugins/init.lua" ~/.config/nvim/lua/plugins/init.lua
ln -nsf "$SCRIPT_DIR/../configbase/vim/lua/config/init.lua" ~/.config/nvim/lua/config/init.lua
ln -nsf "$SCRIPT_DIR/../configbase/vim/lua/util" ~/.config/nvim/lua/util
ln -nsf "$SCRIPT_DIR/../configbase/tmux/.tmux.conf" ~/.tmux.conf
ln -nsf "$SCRIPT_DIR/../configbase/git/.gitconfig" ~/.gitconfig
ln -nsf "$SCRIPT_DIR/../configbase/git/delta" ~/.config/git/delta
touch ~/.config/git/localconfig
