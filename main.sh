#! /usr/bin/bash

./scripts/install-dependencies.sh
./scripts/configure-zsh.sh
./scripts/configure-pwsh.sh
./scripts/configure-nvim.sh
./scripts/configure-tmux.sh
git clone https://github.com/mason1999/manage-vscode-extensions.git "${HOME}/manage-vscode-extensions"
