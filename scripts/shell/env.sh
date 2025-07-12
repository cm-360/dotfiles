#!/usr/bin/env bash

# Dotfiles repo location
export DOTFILES="$HOME/.dotfiles"


########## Path Configuration ##########

# Add user binary directories to path
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/bin:$PATH"
# Add dotfiles scripts to path
export PATH="$DOTFILES/scripts:$PATH"

# Enter Nix user chroot if available
# https://github.com/nix-community/nix-user-chroot
# https://nixos.wiki/wiki/Nix_Installation_Guide#nix-user-chroot
if command -v nix-user-chroot > /dev/null 2>&1 && [ -z "$_NIX_USER_CHROOT_ACTIVE" ]; then
    export _NIX_USER_CHROOT_ACTIVE=1
    exec "$HOME/.local/bin/nix-user-chroot" "$HOME/.nix" "$SHELL"
fi

# Change Go path to hidden directory
export GOPATH="$HOME/.go"
export PATH="$GOPATH/bin:$PATH"

# Prevent creation of `R` directory in $HOME
# https://stackoverflow.com/a/64042444
export R_LIBS_USER="${XDG_DATA_HOME:-$HOME/.local/share}/R/%p-library/%v"

########## Miscellaneous ##########

# Preferred editor
export EDITOR='nano'

# Configure GPG to use the correct TTY
export GPG_TTY="$(tty)"

# Use XDG portal for GTK apps
export GTK_USE_PORTAL=1

# Quiet direnv output
export DIRENV_LOG_FORMAT=

# Use bat as the man pager (if available)
if command -v bat > /dev/null 2>&1; then
    # https://github.com/sharkdp/bat/issues/1731
    export MANPAGER="sh -c 'col -bx | bat -l man -p'"
    export MANROFFOPT="-c"
fi

# Automatically start tmux
# export ZSH_TMUX_AUTOSTART=true

# Prefer KSSHAskPass for ssh-add
if command -v ksshaskpass > /dev/null 2>&1; then
    export SSH_ASKPASS="$(command -v ksshaskpass)"
    export SSH_ASKPASS_REQUIRE="prefer"
fi


########## Nix Environments ##########

# Source environment from Nix system profile
NIX_PROFILE_SCRIPT="$HOME/.nix-profile/etc/profile.d/nix.sh"
if [ -e "$NIX_PROFILE_SCRIPT" ]; then
    . "$NIX_PROFILE_SCRIPT";
fi

# Source environment from Home Manager profile
HM_PROFILE_SCRIPT="$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
if [ -e "$HM_PROFILE_SCRIPT" ]; then
    . "$HM_PROFILE_SCRIPT"
fi
