#!/bin/sh

if command -v eza > /dev/null 2>&1; then
    alias ls="eza"
    alias l="eza -l"
    alias la="eza -la"
    alias laa="eza -laa"
fi

# Fuzzy-find and open a directory in VSCodium with zoxide
zc() {
    zi "$1" && codium . && exit;
}

alias bai="shutdown now"
alias cya="reboot"

alias ip="ip --color=auto"
alias fastfetch="fastfetch -c paleofetch.jsonc"

#alias adb-shizuku="adb shell sh /storage/emulated/0/Android/data/moe.shizuku.privileged.api/start.sh"
alias adb-shizuku="adb shell /data/app/~~xcFWMucY7HgQlOOf7yyoGw==/moe.shizuku.privileged.api-UviotepBCAYoAPXjk7LDmA==/lib/arm64/libshizuku.so"
alias adb-automate="adb shell sh /sdcard/Android/data/com.llamalab.automate/cache/start.sh"

# Home-Manager
alias hm="home-manager"
# Nix/NixOS
alias nf="nix flake"
alias nrb="nixos-rebuild"
alias ncg="nix-collect-garbage"

nix-run() {
    pkg=$1
    shift
    nix run nixpkgs#"$pkg" -- "$@"
}

# https://github.com/getsops/sops/issues/1999#issuecomment-3554147675
sops-host() {
    SOPS_AGE_KEY=$(sudo ssh-to-age -private-key -i /etc/ssh/ssh_host_ed25519_key) \
    sops "$@"
}
