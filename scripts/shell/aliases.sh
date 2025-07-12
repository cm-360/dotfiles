#!/usr/bin/env bash

if command -v eza > /dev/null 2>&1; then
    alias ls="eza"
    alias l="eza -l"
    alias la="eza -la"
    alias laa="eza -laa"
fi

alias bai="shutdown now"
alias cya="reboot"

alias ip="ip --color=auto"
alias fastfetch="fastfetch -c paleofetch.jsonc"

alias adb-shizuku="adb shell sh /storage/emulated/0/Android/data/moe.shizuku.privileged.api/start.sh"
alias adb-automate="adb shell sh /sdcard/Android/data/com.llamalab.automate/cache/start.sh"

nix-run() {
    nix run nixpkgs#"$1" -- "${@:2}"
}
