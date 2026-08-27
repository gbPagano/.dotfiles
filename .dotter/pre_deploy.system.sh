#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)

# Dotter stays unprivileged; only provisioning protected targets needs root.
sudo install -d -m 0755 /etc/greetd /etc/tuigreet /etc/plymouth /boot/loader
sudo ln -sfn "${DOTFILES_DIR}/system/greetd/config.toml" /etc/greetd/config.toml
sudo ln -sfn "${DOTFILES_DIR}/system/greetd/tuigreet/config.toml" /etc/tuigreet/config.toml
sudo ln -sfn "${DOTFILES_DIR}/system/plymouth/plymouthd.conf" /etc/plymouth/plymouthd.conf
sudo install -m 0644 "${DOTFILES_DIR}/system/systemd-boot/loader.conf" /boot/loader/loader.conf
