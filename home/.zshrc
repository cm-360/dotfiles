# https://stevenvanbael.com/profiling-zsh-startup
# zmodload zsh/zprof

########## Oh My Zsh Configuration ##########

# https://github.com/ohmyzsh/ohmyzsh/wiki

# Installation path
export ZSH="$HOME/.oh-my-zsh"

# https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="lukerandall"

# Completion behavior
# CASE_SENSITIVE="true"
# Make _ and - interchangeable, case-sensitive must be off
# HYPHEN_INSENSITIVE="true"
# Display red dots while waiting for completion (or a custom string)
COMPLETION_WAITING_DOTS="true"

# Autosuggestions behavior
ZSH_AUTOSUGGEST_STRATEGY=(history completion)

# Auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time
# Auto-update interval in days
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# History time format
# "mm/dd/yyyy", "dd.mm.yyyy", "yyyy-mm-dd", or 'man strftime' for custom
# HIST_STAMPS="mm/dd/yyyy"

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

# direnv - Auto directory-specific subshells/environments
# https://github.com/direnv/direnv
# https://github.com/nix-community/nix-direnv

# zoxide - A smarter cd command
# https://github.com/ajeetdsouza/zoxide

# Plugins are in $ZSH/plugins and $ZSH_CUSTOM/plugins
plugins=(
    # Shell features
    autoupdate
    ssh-agent

    # Aliases & completions
    common-aliases
    git
    gitignore
    nvm
    poetry
    tmux

    # Suggestions & highlighting
#     alias-tips
    zsh-autosuggestions
    zsh-syntax-highlighting
)

if which direnv > /dev/null; then
    plugins+=(direnv)
fi

if which zoxide > /dev/null; then
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

# zprof
