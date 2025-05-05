#!/usr/bin/env bash

set -e

DOTFILES="$HOME/.dotfiles"

# Clone/update dotfiles repo
if [ ! -d "$DOTFILES" ]; then
    git clone "https://github.com/cm-360/dotfiles.git" "$DOTFILES"
    pushd "$DOTFILES" > /dev/null
    git config --local include.path ../.gitconfig
else
    pushd "$DOTFILES" > /dev/null
    git pull
fi

# Install oh-my-zsh
if which zsh > /dev/null && [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
    echo "⚠️ Oh My Zsh is already installed, skipping."
fi

./update.sh

popd > /dev/null
