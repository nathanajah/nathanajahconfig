#!/bin/bash
shopt -s extglob

NVIM_BASE=~/.config/nvim/
rm -rf $NVIM_BASE/plugins
rm -rf $NVIM_BASE/config
rm -rf $NVIM_BASE/lua/config/!(init.lua)
rm -rf $NVIM_BASE/lua/plugins/!(init.lua)

ZSH_BASE=~/.config/zsh/
rm -rf $ZSH_BASE/modules
mkdir -p $ZSH_BASE/modules
