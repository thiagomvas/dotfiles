# ~/.config/fish/config.fish

# --- Source global definitions ---
# Fish doesn't source /etc/bashrc; system-wide configs for fish are usually in /etc/fish/config.fish

# --- User specific environment variables ---
set -x JAVA_HOME /usr/lib/jvm/java-17-openjdk
set -x ANDROID_HOME $HOME/Android/Sdk

# --- PATH setup ---
# Fish uses a list for PATH; prepend entries if they exist and are not already present

for dir in $HOME/.local/bin $HOME/bin $HOME/.config/ArchiSteamFarm $JAVA_HOME/bin $ANDROID_HOME/tools $ANDROID_HOME/tools/bin $ANDROID_HOME/platform-tools $HOME/.dotnet/tools
    if test -d $dir
        if not contains $dir $PATH
            set -x PATH $dir $PATH
        end
    end
end

# --- SYSTEMD_PAGER ---
# No direct equivalent; you can set environment variables similarly if needed
# set -x SYSTEMD_PAGER ""

# --- GPG_TTY ---
# Fish requires a different approach; you can export env variables similarly:
set -x GPG_TTY (tty)

# --- Source additional scripts ---
if test -d $HOME/.bashrc.d
    for rc in $HOME/.bashrc.d/*.fish
        if test -f $rc
            source $rc
        end
    end
end

# --- fzf initialization ---
if test -f $HOME/.fzf.fish
    source $HOME/.fzf.fish
else if test -f /usr/share/fzf/key-bindings.fish
    source /usr/share/fzf/key-bindings.fish
end

# --- Starship prompt ---
if type -q starship
    starship init fish | source
end

# --- Aliases ---
alias ll='lsd -lah'
alias gs='git status'
alias dotfiles='/usr/bin/git --git-dir=$HOME/dotfiles/ --work-tree=$HOME'
alias editfish='nvim ~/.config/fish/config.fish'
alias reloadfish='source ~/.config/fish/config.fish'

alias ls='lsd'
alias l='ls -l'
alias la='ls -a'
alias lla='ls -la'
alias lt='ls --tree'

alias show-specs="fastfetch --config ~/.config/fastfetch/minimal.jsonc"
alias copy-specs="show-specs | wl-copy"
set fish_greeting
neofetch
