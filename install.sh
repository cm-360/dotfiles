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


./update.sh

popd > /dev/null
