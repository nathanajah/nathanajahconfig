#!/bin/sh

SOURCE=$(realpath "$1")
INSTALL_AS=$2

NVIM_BASE=~/.config/nvim/

mkdir -p $NVIM_BASE/plugins
mkdir -p $NVIM_BASE/config
mkdir -p $NVIM_BASE/lua/plugins
mkdir -p $NVIM_BASE/lua/config

# Install vim
ln -sfn "$SOURCE/vim/plugins" "$NVIM_BASE/plugins/$INSTALL_AS"
ln -sfn "$SOURCE/vim/config" "$NVIM_BASE/config/$INSTALL_AS"
ln -sfn "$SOURCE/vim/lua/plugins" "$NVIM_BASE/lua/plugins/$INSTALL_AS"
ln -sfn "$SOURCE/vim/lua/config" "$NVIM_BASE/lua/config/$INSTALL_AS"

ZSH_BASE=~/.config/zsh/config
mkdir -p $ZSH_BASE/modules

# Install zsh config
ln -sfn "$SOURCE/zsh" "$ZSH_BASE/modules/$INSTALL_AS"

# Install binaries
ln -sfn "$SOURCE/bin" ~/bin/$INSTALL_AS
