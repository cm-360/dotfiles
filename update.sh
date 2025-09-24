#!/usr/bin/env bash

set -e

DOTFILES="$HOME/.dotfiles"
DOTFILES_HOME="$DOTFILES/home"
DOTFILES_SECRETS="$HOME/.dotfiles-secrets"

# Call activation scripts
find "$DOTFILES_HOME" -type f -name "activate" | while read -r source; do
    echo "🚀 Activating: $source"

    (
        cd "$(dirname "$source")" || exit
        ./"$(basename "$source")"
    )
done

# Update symlinks
find "$DOTFILES_HOME" -type f | while read -r source; do
    # Strip dotfiles directory for relative path
    relative_path="${source#"$DOTFILES_HOME"/}"
    target="$HOME/$relative_path"

    mkdir -p "$(dirname "$target")"

    if [ -e "$target" ] || [ -L "$target" ]; then
        echo "⚠️ Removing existing file/symlink: $target"
        rm -f "$target"
    fi

    echo "🔗 Creating symlink: $target -> $source"
    ln -fs "$source" "$target"
done

# Update additional dotfiles from secrets repository
if [ -d "$DOTFILES_SECRETS" ]; then
    "$DOTFILES_SECRETS/update.sh"
fi

# Source new shell environment
. "$DOTFILES/scripts/shell/env.sh"
. "$DOTFILES/scripts/shell/aliases.sh"
