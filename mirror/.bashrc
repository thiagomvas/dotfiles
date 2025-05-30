# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
    export PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
    for rc in ~/.bashrc.d/*; do
        if [ -f "$rc" ]; then
            . "$rc"
        fi
    done
fi
unset rc
export PATH="$HOME/.config/ArchiSteamFarm:$PATH"
export JAVA_HOME="/usr/lib/jvm/java-17-openjdk"
export PATH="$JAVA_HOME/bin:$PATH"
export ANDROID_HOME="/home/thiagomv/Android/Sdk"
export PATH="$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools:$PATH"
export PATH="$HOME/.dotnet/tools:$PATH"

paa() {
    sourceFile="$1"
    execName="$2"

    if [ -z "$sourceFile" ] || [ -z "$execName" ]; then
        echo "Usage: paa <sourceFile> <execName>"
        return 1
    fi

    clear && g++ -o "$execName" "$sourceFile" && hyperfine "./$execName inputs/$execName outputs/$execName"
}

export GPG_TTY=$(tty)

eval "$(starship init bash)"
