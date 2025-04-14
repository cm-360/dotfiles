#!/usr/bin/env bash

DOTFILES="$HOME/.dotfiles"
DOTFILES_HOME="$DOTFILES/home"

if [ ! -d "$DOTFILES" ]; then
    git clone "git@github.com:cm-360/dotfiles.git" "$DOTFILES"
    pushd "$DOTFILES" > /dev/null
    git config --local include.path ../.gitconfig
else
    pushd "$DOTFILES" > /dev/null
    git pull
fi

# Update symlinks
find "$DOTFILES_HOME" -type f | while read -r source; do
    # Strip dotfiles directory for relative path
    relative_path="${source#"$DOTFILES_HOME"/}"
    target="$HOME/$relative_path"

    echo "File: $source"

    # Ensure parent directory exists
    mkdir -p "$(dirname "$target")"

    # Create the symlink, overwriting existing files (use -n to avoid overwriting symlinks)
    if [ -e "$target" ] || [ -L "$target" ]; then
        echo "  ⚠️ Removing existing file/symlink: $target"
        rm -f "$target"
    fi

    echo "  🔗 Creating symlink: $target -> $source"
    ln -fs "$source" "$target"
done

# Source new shell environment
. "$DOTFILES/scripts/shell/env.sh"
. "$DOTFILES/scripts/shell/aliases.sh"

popd > /dev/null
