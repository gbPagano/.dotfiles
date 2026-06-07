#!/usr/bin/env bash
# Dotter post-deploy hook. Runs after every `dotter deploy`.
set -euo pipefail

systemctl --user daemon-reload

# Only enable the awww units when they're actually present, so this is a no-op
# during the system-only deploy (which doesn't link them).
if [ -e "${HOME}/.config/systemd/user/awww.service" ]; then
  systemctl --user enable awww.service awww-overview.service
fi

# Install DMS plugins and enable the dms service once dotter has linked
# ~/.config/DankMaterialShell, so the plugins land in the symlinked config.
if [ -L "${HOME}/.config/DankMaterialShell" ]; then
  # `dms plugins install` exits FATAL on an already-installed plugin; only
  # install the ones not yet listed so re-runs stay idempotent.
  for plugin in netbirdStatus dankHooks; do
    if dms plugins list 2>/dev/null | grep -q "ID: ${plugin}"; then
      echo "DMS plugin ${plugin} already installed, skipping"
    else
      dms plugins install "${plugin}"
    fi
  done

  systemctl --user enable dms.service
fi
