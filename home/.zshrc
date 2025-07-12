# https://stevenvanbael.com/profiling-zsh-startup
# zmodload zsh/zprof


########## Oh My Zsh Configuration ##########

# https://github.com/ohmyzsh/ohmyzsh/wiki

# Installation path
export ZSH="$HOME/.oh-my-zsh"

# https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="lukerandall"

# Completion behavior
CASE_SENSITIVE="false"
# Make _ and - interchangeable, case-sensitive must be off
HYPHEN_INSENSITIVE="true"
# Display red dots while waiting for completion (or a custom string)
COMPLETION_WAITING_DOTS="true"

# Autosuggestions behavior
ZSH_AUTOSUGGEST_STRATEGY=(history completion)

# Auto-update behavior
#   disabled: disable automatic updates
#   auto:     update automatically without asking
#   reminder: just remind me to update when it's time
zstyle ':omz:update' mode auto
# Auto-update interval in days
zstyle ':omz:update' frequency 14

# Uncomment if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# History time format
# "mm/dd/yyyy", "dd.mm.yyyy", "yyyy-mm-dd", or see `man strftime`
HIST_STAMPS="yyyy-mm-dd"


########## Oh My Zsh Plugins ##########

# https://unix.stackexchange.com/a/777123
# Function to install a oh-my-zsh plugin if it doesn't exist
# Parameters:
#   $1 - resource type, either 'plugins' or 'themes'
#   $2 - resource name
#   $3 - resource installtion url
ensure_omz_resource() {
  local resource_type="$1"
  local resource_name="$2"
  local resource_url="$3"

  local omz_resource_dir=${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/$resource_type/$resource_name

  # Check if the resource already exists
  if [ ! -d "$omz_resource_dir" ]; then
    echo "Installing $resource_name of type $resource_type in path: $omz_resource_dir"
    git clone --quiet --depth 1 "$resource_url" "$omz_resource_dir"
  fi
}

ensure_omz_resource "plugins" \
    "autoupdate" \
    "https://github.com/tamcore/autoupdate-oh-my-zsh-plugins"
ensure_omz_resource "plugins" \
    "alias-tips" \
    "https://github.com/djui/alias-tips"
ensure_omz_resource "plugins" \
    "zsh-autosuggestions" \
    "https://github.com/zsh-users/zsh-autosuggestions"
ensure_omz_resource "plugins" \
    "zsh-syntax-highlighting" \
    "https://github.com/zsh-users/zsh-syntax-highlighting"

# $ZSH/plugins
# $ZSH_CUSTOM/plugins
plugins=(
    # Shell features
    autoupdate
    ssh-agent

    # Aliases & completions
    common-aliases
    git
    gitignore

    # Suggestions & highlighting
    zsh-autosuggestions
    zsh-syntax-highlighting
)

# alias-tips - Shows command alias reminders (requires Python 3)
# https://github.com/djui/alias-tips
if which python3 > /dev/null 2>&1; then
    plugins+=(alias-tips)
fi

# direnv - Auto directory-specific subshells/environments
# https://github.com/direnv/direnv
if which direnv > /dev/null 2>&1; then
    plugins+=(direnv)
fi

# Poetry - Python dependency manager
# https://python-poetry.org/
if which poetry > /dev/null 2>&1; then
    plugins+=(poetry)
fi

# tmux - Terminal multiplexer
# https://github.com/tmux/tmux
if which tmux > /dev/null 2>&1; then
    plugins+=(tmux)
fi

# zoxide - A smarter cd command
# https://github.com/ajeetdsouza/zoxide
if which zoxide > /dev/null 2>&1; then
    plugins+=(zoxide)
fi

zstyle ':omz:plugins:ssh-agent' lazy yes
zstyle ':omz:plugins:ssh-agent' lifetime 4h
zstyle ':omz:plugins:ssh-agent' quiet yes

zstyle ':omz:plugins:nvm' lazy yes

. $ZSH/oh-my-zsh.sh


########## User Configuration ##########

# Keybindings
bindkey '^H' backward-kill-word

. ~/.dotfiles/scripts/shell/aliases.sh

# For Termux on Android
if [ "$(uname -o)" = "Android" ]; then
    if ! pidof sshd > /dev/null; then
        echo "Starting sshd..."
        sshd
    fi
fi

# zprof
