#!/bin/bash
# Sets up Pico FIDO integration:
#  - auto-unlock: a udev rule that, on plug-in, triggers a systemd user
#    service which pops up a PIN prompt and decrypts the key's encrypted
#    storage so SSH (touch-only) works until the next power cycle.
#  - touch-to-sudo: registers a pam_u2f credential and wires pam_u2f into
#    /etc/pam.d/sudo so `sudo` accepts a key touch instead of a password.
#    The key must be unlocked (Secure Lock) for this to work, same as SSH.

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
echo "Installing pam-u2f - PAM module for touch-to-sudo authentication"
run $INSTALL libfido2 python-fido2 libnotify pam-u2f

echo "Installing Pico FIDO udev rule to /etc/udev/rules.d"
run sudo ln -sfn "${PICO_DIR}/99-pico-fido.rules" /etc/udev/rules.d/99-pico-fido.rules
run sudo udevadm control --reload

echo "Linking pico-unlock user service and helper script"
run mkdir -p ~/.config/systemd/user ~/.local/bin
run ln -sfn "${PICO_DIR}/pico-unlock.service" ~/.config/systemd/user/pico-unlock.service
run ln -sfn "${PICO_DIR}/pico-unlock.py" ~/.local/bin/pico-unlock
run systemctl --user daemon-reload

"Configuring touch-to-sudo (pam_u2f)"

U2F_MAPPINGS="/etc/u2f_mappings"
PAM_SUDO="/etc/pam.d/sudo"
PAM_LINE="auth       sufficient   pam_u2f.so authfile=${U2F_MAPPINGS} cue"

# Non-resident credential: the credential ID lives in $U2F_MAPPINGS, not on
# the key, so it costs no resident slot. It is device-specific state, so it is
# generated locally (requires a key touch) rather than tracked in the repo.
if [ -f "$U2F_MAPPINGS" ]; then
  echo "$U2F_MAPPINGS already exists - skipping credential registration"
else
  echo "Registering Pico FIDO credential - the key must be UNLOCKED; touch it when it blinks"
  tmp_u2f="$(mktemp)"
  if pamu2fcfg -u "$USER" > "$tmp_u2f" && [ -s "$tmp_u2f" ]; then
    run sudo install -m 600 "$tmp_u2f" "$U2F_MAPPINGS"
    rm -f "$tmp_u2f"
  else
    rm -f "$tmp_u2f"
    echo "pamu2fcfg failed - is the key plugged in and unlocked? Unlock it and re-run." >&2
    exit 1
  fi
fi

# 'sufficient' = a key touch authenticates; otherwise it falls through to the
# password, so a missing/locked key never locks sudo out.
if grep -q "pam_u2f.so" "$PAM_SUDO"; then
  echo "$PAM_SUDO already wired for pam_u2f - skipping"
else
  echo "Adding pam_u2f as a 'sufficient' auth method to $PAM_SUDO"
  run sudo sed -i "/^#%PAM-1.0/a $PAM_LINE" "$PAM_SUDO"
fi

green_echo "========================="
green_echo "Pico FIDO setup complete!"
green_echo "========================="
