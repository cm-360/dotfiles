#!/bin/sh

set -e

DOTFILES="$HOME/.dotfiles"

if command -v git > /dev/null 2>&1; then
    # Clone/update dotfiles repo
    if [ -d "$DOTFILES" ]; then
        pushd "$DOTFILES" > /dev/null
        git pull
    else
        git clone "https://github.com/cm-360/dotfiles.git" "$DOTFILES"
        pushd "$DOTFILES" > /dev/null
        git config --local include.path ../.gitconfig
    fi
else
    if [ -d "$DOTFILES" ]; then
        echo "⚠️ Git is not installed. Skipping repository update."
    else
        echo "🛑 Git is not installed. Please install Git or manually clone the dotfiles repository to '$DOTFILES' and try again."
        exit 1
    fi
fi

if command -v zsh > /dev/null 2>&1; then
    # Install oh-my-zsh
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    else
        echo "⚠️ Oh My Zsh is already installed, skipping."
    fi
else
    echo "⚠️ Zsh is not installed, skipping Oh My Zsh installation."
fi

./update.sh

popd > /dev/null
