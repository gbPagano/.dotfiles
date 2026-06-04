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
INSTALL="paru -S --needed --noconfirm --skipreview"

blue_echo "========================="
blue_echo "Installing Rust toolchain"
blue_echo "========================="

echo "Installing rustup - Rust toolchain manager"
run sudo pacman -S --needed --noconfirm rustup
echo "Setting stable as the default Rust toolchain"
run rustup default stable

blue_echo "=========================="
blue_echo "Setting up Paru AUR helper"
blue_echo "=========================="
if ! command -v paru &>/dev/null; then
  run sudo pacman -S --needed --noconfirm base-devel

  TEMP_DIR=$(mktemp -d)
  echo "Created temporary directory: ${TEMP_DIR}"

  run git clone https://aur.archlinux.org/paru.git "${TEMP_DIR}/paru"

  run cd "${TEMP_DIR}/paru"
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

blue_echo "========================"
blue_echo "Installing Neovim editor"
blue_echo "========================"
run $INSTALL neovim

blue_echo "==============================="
blue_echo "Setting up terminal environment"
blue_echo "==============================="

echo "Installing Zsh - shell"
echo "Installing Ghostty - terminal emulator"
echo "Installing fzf - fuzzy finder"
echo "Installing bat - better cat replacement"
echo "Installing lsd - modern ls replacement"
echo "Installing starship - shell prompt"
echo "Installing zoxide - smarter cd command"
echo "Installing chafa - terminal image viewer"
echo "Installing fd - modern find replacement"
echo "Installing ripgrep - faster grep replacement"
echo "Installing git-delta - syntax-highlighting pager for git"
echo "Installing lazygit - terminal UI for git"
echo "Installing btop - terminal resource monitor"
echo "Installing fastfetch - system information tool"
echo "Installing Jetbrains Mono - nerd font"
run $INSTALL \
  zsh \
  ghostty \
  fzf \
  bat \
  lsd \
  starship \
  zoxide \
  fzf \
  chafa \
  fd \
  ripgrep \
  git-delta \
  lazygit \
  btop \
  fastfetch \
  ttf-jetbrains-mono-nerd

echo "Setting Zsh as default shell"
[ "$(getent passwd "$USER" | cut -d: -f7)" = "/bin/zsh" ] || run chsh -s /bin/zsh "$USER"

echo "Terminal environment setup complete!"

blue_echo "=============================="
blue_echo "Setting up system-level config"
blue_echo "=============================="
source ${SCRIPT_DIR}/system/setup.sh

blue_echo "========================================"
blue_echo "Installing toml-bombadil dotfile manager"
blue_echo "========================================"

run $INSTALL toml-bombadil

echo "Linking dotfiles with bombadil"
run bombadil install "${SCRIPT_DIR}"
run bombadil link -f

green_echo "==============================="
green_echo "Dotfiles installation complete!"
green_echo "==============================="
