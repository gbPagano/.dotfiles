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
NVIDIA="${NVIDIA:-true}"
PICO_FIDO="${PICO_FIDO:-true}"

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
  ttf-jetbrains-mono-nerd

echo "Setting Zsh as default shell"
[ "$(getent passwd "$USER" | cut -d: -f7)" = "/bin/zsh" ] || run chsh -s /bin/zsh "$USER"

echo "Terminal environment setup complete!"

blue_echo "=============================="
blue_echo "Setting up system-level config"
blue_echo "=============================="

echo "Creating XDG user directories"
run mkdir -p ~/documents ~/downloads ~/pictures ~/projects ~/videos

echo "Installing niri - scrollable-tiling wayland compositor"
echo "Installing dms-shell - Dank Material Shell desktop environment"
echo "Installing plymouth - graphical boot splash screen"
echo "Installing greetd - minimal login manager daemon"
echo "Installing greetd-tuigreet-fork - TUI greeter for greetd"
echo "Installing unzip - utility for extracting zip files"
run $INSTALL \
  niri \
  dms-shell-niri \
  plymouth \
  greetd \
  greetd-tuigreet-fork-git \
  unzip

echo "Installing catppuccin-mocha-dark-cursors"
run mkdir -p ~/.local/share/icons
run curl -L -s -o /tmp/catppuccin-mocha-dark-cursors.zip https://github.com/catppuccin/cursors/releases/download/v2.0.0/catppuccin-mocha-dark-cursors.zip
run unzip -o -q /tmp/catppuccin-mocha-dark-cursors.zip -d ~/.local/share/icons
run rm -f /tmp/catppuccin-mocha-dark-cursors.zip


DOTFILES_ABS=$(realpath "${SCRIPT_DIR}")

echo "Enabling dms user service"
run systemctl --user enable dms.service

echo "Installing greetd config to /etc/greetd and enabling service"
run sudo mkdir -p /etc/greetd
run sudo ln -sfn "${DOTFILES_ABS}/system/greetd/config.toml" /etc/greetd/config.toml
echo "Installing tuigreet config to /etc/tuigreet"
run sudo mkdir -p /etc/tuigreet
run sudo ln -sfn "${DOTFILES_ABS}/system/greetd/tuigreet/config.toml" /etc/tuigreet/config.toml

# greetd runs tuigreet as the unprivileged `greeter` user, but the config
# installed above is a symlink into this user's home. The kernel enforces
# traversal (x) permission on every path component, so grant `greeter` the
# ACLs needed to follow the symlink; otherwise tuigreet silently uses defaults.
echo "Granting greeter user access to the tuigreet config symlink target"
run sudo setfacl -m u:greeter:x \
  "/home/${USER}" \
  "${DOTFILES_ABS}" \
  "${DOTFILES_ABS}/system" \
  "${DOTFILES_ABS}/system/greetd" \
  "${DOTFILES_ABS}/system/greetd/tuigreet"
run sudo setfacl -m u:greeter:r "${DOTFILES_ABS}/system/greetd/tuigreet/config.toml"

run sudo systemctl enable greetd

if [ "${PICO_FIDO}" = "true" ]; then
  source ${SCRIPT_DIR}/system/pico-fido/setup.sh
fi

echo "Silencing niri-session logs for a silent boot"
run sudo sed -i 's|^Exec=.*|Exec=niri-session > /dev/null 2>\&1|' /usr/share/wayland-sessions/niri.desktop

# The AUR plymouth-theme-abstract-ring-git package clones the entire ~247 MB
# adi1090x/plymouth-themes repo just to extract one 3.5 MB theme. Fetch the
# prebuilt theme tarball from the upstream v1.0 release instead.
echo "Installing abstract_ring plymouth theme from upstream release"
PLYMOUTH_THEME_TMP=$(mktemp -d)
run curl -fsSL -o "${PLYMOUTH_THEME_TMP}/abstract_ring.tar.gz" \
  "https://github.com/adi1090x/plymouth-themes/releases/download/v1.0/abstract_ring.tar.gz"
run sudo mkdir -p /usr/share/plymouth/themes
run sudo tar -xzf "${PLYMOUTH_THEME_TMP}/abstract_ring.tar.gz" -C /usr/share/plymouth/themes
run rm -rf "${PLYMOUTH_THEME_TMP}"

echo "Installing plymouth daemon config (theme = abstract_ring)"
run sudo install -Dm644 "${DOTFILES_ABS}/system/plymouth/plymouthd.conf" /etc/plymouth/plymouthd.conf

echo "Installing systemd-boot loader.conf (timeout 0, editor disabled)"
run sudo install -Dm644 "${DOTFILES_ABS}/system/systemd-boot/loader.conf" /boot/loader/loader.conf

echo "Injecting plymouth hook into /etc/mkinitcpio.conf (if missing)"
sudo bash -c "grep -q 'HOOKS=.*plymouth' /etc/mkinitcpio.conf || { sed -i '/^HOOKS=/ s/udev/udev plymouth/' /etc/mkinitcpio.conf && mkinitcpio -P; }"

echo "Appending plymouth params to /etc/kernel/cmdline (if missing)"
sudo bash -c "grep -q 'quiet splash' /etc/kernel/cmdline || { sed -i 's|\$| quiet splash loglevel=3 rd.udev.log_level=3 vt.global_cursor_default=0 systemd.show_status=false|' /etc/kernel/cmdline && sudo mkinitcpio -P; }"

if [ "${NVIDIA}" = "true" ]; then
  source ${SCRIPT_DIR}/system/nvidia/setup.sh
fi

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
