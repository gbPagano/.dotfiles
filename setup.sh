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
echo "Installing ripgrep - faster grep replacement"
echo "Installing git-delta - syntax-highlighting pager for git"
echo "Installing Jetbrains Mono - nerd font"
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
  git-delta \
  catppuccin-cursors-mocha \
  ttf-jetbrains-mono-nerd

echo "Setting Zsh as default shell"
run chsh -s /bin/zsh $USER

echo "Terminal environment setup complete!"

blue_echo "=============================="
blue_echo "Setting up system-level config"
blue_echo "=============================="

echo "Installing niri - scrollable-tiling wayland compositor"
echo "Installing catppuccin-cursors-mocha - mocha flavor of catppuccin cursors"
echo "Installing dms-shell - Dank Material Shell desktop environment"
echo "Installing plymouth - graphical boot splash screen"
echo "Installing plymouth-theme-abstract-ring-git - abstract ring theme for plymouth"
echo "Installing greetd - minimal login manager daemon"
echo "Installing greetd-tuigreet-fork-bin - TUI greeter for greetd"
run paru -S --needed \
  niri \
  catppuccin-cursors-mocha \
  dms-shell \
  plymouth \
  plymouth-theme-abstract-ring-git \
  greetd \
  greetd-tuigreet-fork-bin

DOTFILES_ABS=$(realpath "${SCRIPT_DIR}")

echo "Enabling dms user service"
run systemctl --user enable dms.service

echo "Installing greetd config to /etc/greetd and enabling service"
run sudo mkdir -p /etc/greetd
run sudo ln -sfn "${DOTFILES_ABS}/system/greetd/config.toml" /etc/greetd/config.toml
echo "Installing tuigreet config to /etc/tuigreet"
run sudo mkdir -p /etc/tuigreet
run sudo ln -sfn "${DOTFILES_ABS}/system/greetd/tuigreet/config.toml" /etc/tuigreet/config.toml

run sudo systemctl enable greetd

echo "Silencing niri-session logs for a silent boot"
run sudo sed -i 's|^Exec=.*|Exec=niri-session > /dev/null 2>\&1|' /usr/share/wayland-sessions/niri.desktop

echo "Installing plymouth daemon config (theme = abstract_ring)"
run sudo install -Dm644 "${DOTFILES_ABS}/system/plymouth/plymouthd.conf" /etc/plymouth/plymouthd.conf

echo "Installing systemd-boot loader.conf (timeout 0, editor disabled)"
run sudo install -Dm644 "${DOTFILES_ABS}/system/systemd-boot/loader.conf" /boot/loader/loader.conf

echo "Injecting plymouth hook into /etc/mkinitcpio.conf (if missing)"
sudo bash -c "grep -q 'HOOKS=.*plymouth' /etc/mkinitcpio.conf || { sed -i '/^HOOKS=/ s/udev/udev plymouth/' /etc/mkinitcpio.conf && mkinitcpio -P; }"

echo "Appending plymouth params to /etc/kernel/cmdline (if missing)"
sudo bash -c "grep -q 'quiet splash' /etc/kernel/cmdline || { sed -i 's|\$| quiet splash loglevel=3 rd.udev.log_level=3 vt.global_cursor_default=0 systemd.show_status=false|' /etc/kernel/cmdline && sudo mkinitcpio -P; }"

blue_echo "========================================"
blue_echo "Installing toml-bombadil dotfile manager"
blue_echo "========================================"

run paru -S --needed --noconfirm toml-bombadil

echo "Linking dotfiles with bombadil"
run bombadil install "${SCRIPT_DIR}"
run bombadil link -f

green_echo "==============================="
green_echo "Dotfiles installation complete!"
green_echo "==============================="
