#!/bin/bash
# Sets up Pico FIDO auto-unlock: a udev rule that, on plug-in, triggers a
# systemd user service which pops up a PIN prompt and decrypts the key's
# encrypted storage so SSH (touch-only) works until the next power cycle.

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

PICO_DIR=$(dirname "$(realpath "${BASH_SOURCE[0]}")")
INSTALL="paru -S --needed --noconfirm --skipreview"

blue_echo "===================="
blue_echo "Setting up Pico FIDO"
blue_echo "===================="

echo "Installing libfido2 - FIDO2 lib; openssh's sk-helper uses it for SSH keys"
echo "Installing python-fido2 - pure-Python CTAP2 lib used by the unlock script"
echo "Installing libnotify - desktop notifications (notify-send)"
run $INSTALL libfido2 python-fido2 libnotify

echo "Installing Pico FIDO udev rule to /etc/udev/rules.d"
run sudo ln -sfn "${PICO_DIR}/99-pico-fido.rules" /etc/udev/rules.d/99-pico-fido.rules
run sudo udevadm control --reload

echo "Linking pico-unlock user service and helper script"
run mkdir -p ~/.config/systemd/user ~/.local/bin
run ln -sfn "${PICO_DIR}/pico-unlock.service" ~/.config/systemd/user/pico-unlock.service
run ln -sfn "${PICO_DIR}/pico-unlock.py" ~/.local/bin/pico-unlock
run systemctl --user daemon-reload

green_echo "========================="
green_echo "Pico FIDO setup complete!"
green_echo "========================="
