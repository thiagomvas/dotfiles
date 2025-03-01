#!/bin/bash

# Check for the --test parameter
if [[ "$1" == "--test" ]]; then
  TEMP_HOME=$(mktemp -d)
  echo "Running in test mode. Using temporary directory: $TEMP_HOME"
else
  TEMP_HOME="$HOME"
  echo "Running in normal mode. Using home directory: $TEMP_HOME"
fi

# Define dotfiles directory
DOTFILES_DIR="$(pwd)"
CONFIG_DIR="$TEMP_HOME/.config"

mkdir -p "$CONFIG_DIR"


# Logging setup
LOGFILE="$TEMP_HOME/setup.log"
exec > >(tee -i "$LOGFILE") 2>&1

# Copy all directories and files from .config in dotfiles to the actual system's .config directory
for config_item in "$DOTFILES_DIR/.config"/*; do
    if [ -d "$config_item" ]; then
        # If it's a directory, copy the directory recursively
        folder_name=$(basename "$config_item")
        target_dir="$CONFIG_DIR/$folder_name"
        mkdir -p "$target_dir"
        echo "Copying directory $folder_name to $target_dir"
        cp -r "$config_item/"* "$target_dir/"
    elif [ -f "$config_item" ]; then
        # If it's a file, copy it directly
        file_name=$(basename "$config_item")
        target_file="$CONFIG_DIR/$file_name"
        echo "Copying file $file_name to $target_file"
        cp "$config_item" "$target_file"
    fi
done

# Backup existing configuration files in the appropriate directory
for file in .bashrc .gitconfig; do
  if [ -e "$TEMP_HOME/$file" ]; then
    mv "$TEMP_HOME/$file" "$TEMP_HOME/${file}.bak"
    echo "Backed up $file to ${file}.bak"
  fi
done

# Create symlinks in the appropriate directory
ln -sf "$DOTFILES_DIR/.bashrc" "$TEMP_HOME/.bashrc" || {
  echo "Failed to create symlink for .bashrc"
  exit 1
}
ln -sf "$DOTFILES_DIR/.gitconfig" "$TEMP_HOME/.gitconfig" || {
  echo "Failed to create symlink for .gitconfig"
  exit 1
}

# Init submodules
git submodule update --init --recursive

# Copy the Neovim config to the appropriate location
if [ ! -d "$TEMP_HOME/.config/nvim" ]; then
  mkdir -p "$TEMP_HOME/.config"
  cp -r "$DOTFILES_DIR/nvim" "$TEMP_HOME/.config/nvim"
else
  echo "Neovim config already exists. Update it if needed."
fi

# Install packages from .packages file
if [ -f "$DOTFILES_DIR/.packages" ]; then
  echo "Do you want to install the packages listed in .packages? (y/n) "
  read -n 1 -r
  echo # Move to a new line

  if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "Installing packages..."
    while IFS= read -r package; do
      # Check if the package is already installed
      if dnf list installed "$package" &>/dev/null; then
        echo "Package '$package' is already installed. Skipping."
      else
        echo "Installing package: $package"
        sudo dnf install -y "$package" || echo "Failed to install $package"
      fi
    done <"$DOTFILES_DIR/.packages"
  else
    echo "Skipping package installation."
  fi
else
  echo ".packages file not found."
fi

echo "Dotfiles setup complete in $TEMP_HOME!"
