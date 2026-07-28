#!/usr/bin/env bash
# Dotter post-deploy hook. Runs after every `dotter deploy`.
set -euo pipefail

systemctl --user daemon-reload

# Use the named theme where GTK supports it and let libadwaita apps keep their
# own styles while following the desktop color scheme.
if gsettings writable org.gnome.desktop.interface gtk-theme >/dev/null 2>&1; then
  gsettings set org.gnome.desktop.interface gtk-theme "Colloid-Dark-Catppuccin"
  gsettings set org.gnome.desktop.interface icon-theme "Papirus-Dark"
  gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"
fi

# Only enable the awww units when they're actually present, so this is a no-op
# during the system-only deploy (which doesn't link them).
if [ -e "${HOME}/.config/systemd/user/awww.service" ]; then
  systemctl --user enable awww.service awww-overview.service
fi

# Install DMS plugins once Dotter has created the real config directory.
if [ -d "${HOME}/.config/DankMaterialShell" ]; then
  # `dms plugins install` exits FATAL on an already-installed plugin; only
  # install the ones not yet listed so re-runs stay idempotent.
  for plugin in netbirdStatus dankHooks Calculator; do
    if dms plugins list 2>&1 | grep -Fi "ID: ${plugin}" >/dev/null; then
      echo "DMS plugin ${plugin} already installed, skipping"
    else
      dms plugins install "${plugin}"
    fi
  done

  systemctl --user enable dms.service
fi
