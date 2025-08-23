# ~/.bashrc

# --- Source global definitions (if present) ---
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# --- User specific environment variables (define before PATH) ---
export JAVA_HOME="/usr/lib/jvm/java-17-openjdk"
export ANDROID_HOME="$HOME/Android/Sdk"

# --- PATH: add custom dirs once, in priority order ---
_local_paths=(
    "$HOME/.local/bin"
    "$HOME/bin"
    "$HOME/.config/ArchiSteamFarm"
    "$JAVA_HOME/bin"
    "$ANDROID_HOME/tools"
    "$ANDROID_HOME/tools/bin"
    "$ANDROID_HOME/platform-tools"
    "$HOME/.dotnet/tools"
)

export PATH=/usr/lib64/openmpi/bin:$PATH

for dir in "${_local_paths[@]}"; do
    if [ -n "$dir" ] && [ -d "$dir" ] && [[ ":$PATH:" != *":$dir:"* ]]; then
        PATH="$dir:$PATH"
    fi
done
unset _local_paths dir

export PATH

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# Uncomment to make gpg use the current tty when needed
export GPG_TTY=$(tty)

# --- Include additional user scripts ---
if [ -d "$HOME/.bashrc.d" ]; then
    for rc in "$HOME/.bashrc.d"/*; do
        if [ -f "$rc" ]; then
            . "$rc"
        fi
    done
fi

# --- fzf (fuzzy-finder) initialization ---
if [ -f "$HOME/.fzf.bash" ]; then
    source "$HOME/.fzf.bash"
elif [ -f /usr/share/fzf/key-bindings.bash ]; then
    source /usr/share/fzf/key-bindings.bash
fi
# Install fzf (if missing): sudo dnf install fzf  OR git clone https://github.com/junegunn/fzf && ./install

# --- Starship prompt ---
if command -v starship >/dev/null 2>&1; then
    eval "$(starship init bash)"
fi
# Install starship: curl -sS https://starship.rs/install.sh | sh

# --- Enable wildcard expansion on Tab ---
shopt -s direxpand

# Remove bash-completion overrides for common file commands so wildcards expand on Tab
complete -r rm
complete -r mv
complete -r cp

# --- User aliases and functions ---
alias ll='ls -lah --color=auto'
alias gs='git status'

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
