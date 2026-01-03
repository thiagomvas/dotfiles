# --- Only run interactive stuff in interactive shells ----------------
if not status --is-interactive
    return
end

# --- Configuration: set fish variables ------------------------------
# Set editor if not set yet
if not set -q EDITOR
    set -Ux EDITOR nvim
end
function set-editor --description 'Set the default editor for fish'
    if test (count $argv) -eq 1
        set -e EDITOR          # remove any existing shadow
        set -Ux EDITOR $argv[1]
        echo "Editor set to: $EDITOR"
    else
        echo "Usage: set-editor <editor-command>"
    end
end



# --- Environment: only set variables if the directories exist ---------
# Java
if test -d /usr/lib/jvm/java-17-openjdk
    set -x JAVA_HOME /usr/lib/jvm/java-17-openjdk
end

# Android SDK
if test -d $HOME/Android/Sdk
    set -x ANDROID_HOME $HOME/Android/Sdk
end

# --- PATH setup: prepend if directory exists & not already present -----
set -l _user_paths \
    $HOME/.local/bin \
    $HOME/bin \
    $HOME/.config/ArchiSteamFarm \
    $JAVA_HOME/bin \
    $ANDROID_HOME/tools \
    $ANDROID_HOME/tools/bin \
    $ANDROID_HOME/platform-tools \
    $HOME/.dotnet/tools

for dir in $_user_paths
    if test -n "$dir" -a -d $dir
        if not contains -- $dir $PATH
            set -x PATH $dir $PATH
        end
    end
end

# --- GPG_TTY (helpful for gpg pinentry) -------------------------------
if not set -q GPG_TTY
    set -x GPG_TTY (tty)
end

# --- Source small per-shell snippets (optional) ------------------------
# Keep personal per-command snippets in ~/.bashrc.d/*.fish (optional)
if test -d $HOME/.bashrc.d
    for rc in $HOME/.bashrc.d/*.fish
        if test -f $rc
            source $rc
        end
    end
end

# --- Function autoloading (recommended) -------------------------------
# Fish autoloads functions from ~/.config/fish/functions/ automatically.
# Do NOT manually source every file here — keep functions in that dir.
# (If you still want to source a single script, do so explicitly.)

# --- fzf key bindings (if installed) ---------------------------------
if test -f $HOME/.fzf.fish
    source $HOME/.fzf.fish
else if test -f /usr/share/fzf/key-bindings.fish
    source /usr/share/fzf/key-bindings.fish
end

# --- Prompt: starship (idiomatic) ------------------------------------
if type -q starship
    eval (starship init fish)
end

# --- Performance / UI tweaks ------------------------------------------
# Disable interactive greeting to speed up startup
set fish_greeting

# --- Aliases & abbreviations (grouped) -------------------------------
# Core aliases
alias ll='lsd -lah'
alias ls='lsd'
alias l='ls -l'
alias la='ls -a'
alias lla='ls -la'
alias lt='ls --tree'
alias cat='bat'

alias dcdev='docker compose -f "docker-compose.dev.yml"'
alias dcp='docker compose -f "docker-compose.prod.yml"'

alias dstop='docker stop (docker ps -q)'
alias drm='docker rm (docker ps -a -q)'

# Git + dotfiles
alias gs='git status'
alias dotfiles='/usr/bin/git --git-dir=$HOME/dotfiles/ --work-tree=$HOME'

# Config helpers
alias editfish='code ~/.config/fish/'
function reloadfish
    # syntax-check before reloading
    if fish -c 'source ~/.config/fish/config.fish' >/dev/null 2>&1
        source ~/.config/fish/config.fish
    else
        echo "Syntax error: config.fish not reloaded." >&2
    end
end


# Utilities
alias show-specs="fastfetch --config ~/.config/fastfetch/minimal.jsonc"
alias copy-specs="show-specs | wl-copy"

alias vpn-on="tailscale up --exit-node=100.109.151.18 --exit-node-allow-lan-access"
alias vpn-off="tailscale down"

alias cs="csharprepl"

# Useful abbreviations
abbr -a dl 'cd ~/Downloads'
abbr -a dc 'cd ~/Documents'

# --- Optional interactive toys (only if installed) --------------------
if type -q neofetch
    neofetch
end

