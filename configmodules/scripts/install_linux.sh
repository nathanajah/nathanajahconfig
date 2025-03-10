#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
MODULE_DIR="$SCRIPT_DIR/../modules/"

"$SCRIPT_DIR/install_module.sh" "$MODULE_DIR/base" 00_base
"$SCRIPT_DIR/install_module.sh" "$MODULE_DIR/dev" 50_dev
"$SCRIPT_DIR/install_module.sh" "$MODULE_DIR/colorscheme" 90_colorscheme
