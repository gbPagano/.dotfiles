#!/usr/bin/env bash
# Dotter post-deploy hook. Runs after every `dotter deploy`.
set -euo pipefail

systemctl --user daemon-reload

# Only enable the awww units when they're actually present, so this is a no-op
# during the system-only deploy (which doesn't link them).
if [ -e "${HOME}/.config/systemd/user/awww.service" ]; then
  systemctl --user enable awww.service awww-overview.service
fi
