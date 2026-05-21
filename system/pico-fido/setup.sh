#!/bin/bash
# Sets up Pico FIDO integration:
#  - auto-unlock: a udev rule that, on plug-in, triggers a systemd user
#    service which pops up a PIN prompt and decrypts the key's encrypted
#    storage so SSH (touch-only) works until the next power cycle.
#  - sudo auth: sudo asks for the password by default; the `usudo` (u2f sudo)
#    shell function opts a single call into a Pico FIDO touch instead, via a
#    pam_exec marker plus pam_u2f. Needs the key unlocked, same as SSH.

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

echo "Configuring sudo authentication"

U2F_MAPPINGS="/etc/u2f_mappings"
PAM_SUDO="/etc/pam.d/sudo"
SUDO_CHECK="/usr/local/bin/u2f-sudo-check"
PAM_EXEC_LINE="auth       [success=ignore default=1]   pam_exec.so quiet ${SUDO_CHECK}"
PAM_U2F_LINE="auth       sufficient                   pam_u2f.so authfile=${U2F_MAPPINGS} cue"

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

echo "Installing $SUDO_CHECK - pam_exec helper that opts a sudo call into u2f"
run sudo install -m 755 "${PICO_DIR}/u2f-sudo-check" "$SUDO_CHECK"

# sudo asks for the password by default. The `usudo` shell function drops a
# one-shot marker that makes u2f-sudo-check exit 0, so pam_exec's
# 'success=ignore' continues to pam_u2f (key touch). With no marker,
# 'default=1' skips pam_u2f straight to the password. pam_u2f stays
# 'sufficient', so a locked/missing key still falls back to the password.
# Lines are deleted first so re-runs (and the control flip) stay idempotent.
echo "Wiring pam_exec + pam_u2f into $PAM_SUDO"
run sudo sed -i '\#pam_exec\.so.*u2f#d; /pam_u2f\.so/d' "$PAM_SUDO"
run sudo sed -i "/^#%PAM-1.0/a $PAM_U2F_LINE" "$PAM_SUDO"
run sudo sed -i "/^#%PAM-1.0/a $PAM_EXEC_LINE" "$PAM_SUDO"

green_echo "========================="
green_echo "Pico FIDO setup complete!"
green_echo "========================="
