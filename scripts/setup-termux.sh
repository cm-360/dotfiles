#!/usr/bin/env bash

set -e


########## Install Packages ##########

# Set repositories and upgrade all packages
termux-change-repo
yes | pkg update && pkg upgrade

pkg install -y \
    bat \
    eza \
    fastfetch \
    git \
    openssh \
    python-pip \
    python3 \
    tmux \
    which \
    zoxide \
    zsh


########## Shizuku Integration ##########

# Grant storage access and setup symlinks
if [ ! -d "$HOME/storage" ]; then
    termux-setup-storage
fi

echo ""
echo "Setting up Shizuku Rish integration..."
echo "Before proceeding, please:"
echo "  1. Open the Shizuku app."
echo "  2. Go to 'Use Shizuku in terminal apps'."
echo "  3. Tap 'Export files'."
echo "  4. Choose or create a folder named 'rish'."
echo ""
read -p "Press Enter once you have completed the above steps."

RISH_EXPORT_DIR="$HOME/storage/shared/rish"
TERMUX_BIN_DIR="/data/data/com.termux/files/usr/bin"

if [ -d "$RISH_EXPORT_DIR" ]; then
    cp "$RISH_EXPORT_DIR/rish" "$TERMUX_BIN_DIR/rish"
    cp "$RISH_EXPORT_DIR/rish_shizuku.dex" "$TERMUX_BIN_DIR/rish_shizuku.dex"
    sed -i 's/PKG/com.termux/g' "$TERMUX_BIN_DIR/rish"
    chmod +x "$TERMUX_BIN_DIR/rish"
else
    echo "⚠️ Missing 'rish' directory, skipping."
fi


########## Dotfiles and Shell ##########

# Setup dotfiles
curl -fsSL "https://raw.githubusercontent.com/cm-360/dotfiles/refs/heads/main/install.sh" | bash

# Change default shell to zsh
chsh -s zsh
zsh && exit
