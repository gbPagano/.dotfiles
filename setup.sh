#!/bin/bash
# Install and configures all dependencies

run() {
  echo -e "\033[1;34m$ $@\033[0m"
  "$@"
}

blue_echo() {
  echo -e "\033[1;34m$@\033[0m"
}

green_echo() {
  echo -e "\033[0;32m$@\033[0m"
}

SCRIPT_DIR=$(dirname "$0")

blue_echo "=========================="
blue_echo "Setting up Paru AUR helper"
blue_echo "=========================="
if ! command -v paru &>/dev/null; then
  run sudo pacman -S --needed --noconfirm base-devel

  TEMP_DIR=$(mktemp -d)
  echo "Created temporary directory: ${TEMP_DIR}"

  run git clone https://aur.archlinux.org/paru-bin.git "${TEMP_DIR}/paru-bin"

  run cd "${TEMP_DIR}/paru-bin"
  run makepkg -si --noconfirm

  echo "Cleaning up..."
  run rm -rf "${TEMP_DIR}"

  if command -v paru &>/dev/null; then
    echo "Paru installation successful!"
    paru --version
  else
    echo "Paru installation failed."
    exit 1
  fi

  echo "You can now use 'paru' to install packages from the AUR."
else
  echo "Paru is already installed."
fi

blue_echo "==================================="
blue_echo "Installing Kanata keyboard remapper"
blue_echo "==================================="
source ${SCRIPT_DIR}/kanata/setup.sh

blue_echo "========================"
blue_echo "Installing Neovim editor"
blue_echo "========================"
run paru -S --needed neovim

blue_echo "==============================="
blue_echo "Setting up terminal environment"
blue_echo "==============================="

echo "Installing Zsh - shell"
echo "Installing WezTerm - terminal emulator"
echo "Installing fzf - fuzzy finder"
echo "Installing bat - better cat replacement"
echo "Installing lsd - modern ls replacement"
echo "Installing starship - shell prompt"
echo "Installing zoxide - smarter cd command"
echo "Installing chafa - terminal image viewer"
echo "Installing fd - modern find replacement"
run paru -S --needed \
  zsh \
  wezterm \
  fzf \
  bat \
  lsd \
  starship \
  zoxide \
  fzf \
  chafa \
  fd \
  ripgrep \
  git-delta

echo "Setting Zsh as default shell"
run chsh -s /bin/zsh $USER

echo "Terminal environment setup complete!"

blue_echo "========================================"
blue_echo "Installing toml-bombadil dotfile manager"
blue_echo "========================================"

run paru -S --needed --noconfirm toml-bombadil

echo "Linking dotfiles with bombadil"
run bombadil install "${SCRIPT_DIR}"
run bombadil link

green_echo "==============================="
green_echo "Dotfiles installation complete!"
green_echo "==============================="
