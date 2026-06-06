#!/bin/bash
# Installs and configures system-level components: kanata keyboard remapper,
# niri desktop environment, GTK/icon/cursor theming, greetd login manager,
# plymouth boot splash, and optional NVIDIA / Pico FIDO integrations.

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

# Install a DMS plugin only if it isn't already present. `dms plugins install`
# exits FATAL on an already-installed plugin, which breaks setup re-runs.
dms_plugin_install() {
  if dms plugins list 2>/dev/null | grep -q "ID: $1"; then
    echo "DMS plugin $1 already installed, skipping"
  else
    run dms plugins install "$1"
  fi
}

SYSTEM_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
DOTFILES_ABS=$(realpath "${SYSTEM_DIR}/..")
INSTALL="${INSTALL:-paru -S --needed --noconfirm --skipreview}"
NVIDIA="${NVIDIA:-true}"
PICO_FIDO="${PICO_FIDO:-true}"

echo "Installing Kanata keyboard remapper"
# Install kanata and run it as a systemd service that loads our keymap.
KANATA_FILE="${SYSTEM_DIR}/kanata/kanata.kbd"
KANATA_SERVICE="/etc/systemd/system/kanata.service"

echo "Creating the kanata service file at ${KANATA_SERVICE}"
sudo sh -c "cat > ${KANATA_SERVICE} << EOF
[Unit]
Description=Kanata Service
Requires=local-fs.target
After=local-fs.target

[Service]
ExecStartPre=/usr/bin/modprobe uinput
ExecStart=/usr/bin/kanata -c ${KANATA_FILE}
Restart=no

[Install]
WantedBy=sysinit.target
EOF"

run $INSTALL kanata-bin

echo "Reloading systemd daemon"
run sudo systemctl daemon-reload
echo "Enabling and starting the kanata service"
run sudo systemctl enable kanata
run sudo systemctl start kanata

echo "Creating XDG user directories"
run mkdir -p ~/documents ~/downloads ~/pictures ~/projects ~/videos

echo "Installing niri - scrollable-tiling wayland compositor"
echo "Installing dms-shell - Dank Material Shell desktop environment"
echo "Installing awww - Wayland wallpaper daemon (sharp workspace bg + overview backdrop)"
echo "Installing plymouth - graphical boot splash screen"
echo "Installing greetd - minimal login manager daemon"
echo "Installing greetd-tuigreet-fork - TUI greeter for greetd"
echo "Installing unzip - utility for extracting zip files"
echo "Installing usbutils - USB device listing utilities (lsusb)"
echo "Installing Papirus icon theme"
echo "Installing netbird - WireGuard-based mesh VPN client"
echo "Installing imagemagick - pre-blurs the wallpaper for the niri overview backdrop"
echo "Installing gsettings-desktop-schemas - provides org.gnome.desktop.interface schema (icon theme / color scheme)"
run $INSTALL \
  niri \
  dms-shell-niri \
  awww \
  imagemagick \
  plymouth \
  greetd \
  greetd-tuigreet-fork-git \
  unzip \
  usbutils \
  papirus-icon-theme \
  gsettings-desktop-schemas \
  netbird-bin

# The AUR colloid-catppuccin-gtk-theme-git clones the full git history (~50 MB)
# and compiles all SASS variants. Fetch just the release tarball and install
# only the dark+catppuccin variant we actually use.
echo "Installing Colloid Catppuccin GTK theme from latest GitHub release"
run $INSTALL sassc
COLLOID_TMP=$(mktemp -d)
COLLOID_TAG=$(curl -fsSL "https://api.github.com/repos/vinceliuice/Colloid-gtk-theme/releases/latest" \
  | grep '"tag_name"' | head -1 | cut -d'"' -f4)
run curl -fsSL -o "${COLLOID_TMP}/colloid.tar.gz" \
  "https://github.com/vinceliuice/Colloid-gtk-theme/archive/refs/tags/${COLLOID_TAG}.tar.gz"
run tar -xzf "${COLLOID_TMP}/colloid.tar.gz" -C "${COLLOID_TMP}"
run sudo bash "${COLLOID_TMP}/Colloid-gtk-theme-${COLLOID_TAG}/install.sh" \
  --color dark --tweaks catppuccin
run rm -rf "${COLLOID_TMP}"

echo "Setting GTK_THEME in /etc/environment (GTK4 apps)"
sudo bash -c "grep -q 'GTK_THEME' /etc/environment || echo 'GTK_THEME=Colloid-Dark-Catppuccin' >> /etc/environment"

echo "Applying GTK icon theme and color scheme via gsettings"
run gsettings set org.gnome.desktop.interface icon-theme "Papirus-Dark"
run gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"

echo "Installing catppuccin-mocha-dark-cursors"
run mkdir -p ~/.local/share/icons
run curl -L -s -o /tmp/catppuccin-mocha-dark-cursors.zip https://github.com/catppuccin/cursors/releases/download/v2.0.0/catppuccin-mocha-dark-cursors.zip
run unzip -o -q /tmp/catppuccin-mocha-dark-cursors.zip -d ~/.local/share/icons
run rm -f /tmp/catppuccin-mocha-dark-cursors.zip

echo "Installing netbirdStatus plugin from DMS registry"
dms_plugin_install netbirdStatus

echo "Installing dankHooks plugin from DMS registry (wallpaper -> awww hook)"
dms_plugin_install dankHooks

echo "Enabling dms user service"
run systemctl --user enable dms.service

# Deploy the root-owned `system` packages with dotter. 
echo "Deploying system config (greetd, tuigreet, plymouth, systemd-boot) with dotter"
( cd "${DOTFILES_ABS}" && run dotter \
    --local-config .dotter/local.system.toml \
    --cache-file .dotter/cache.system.toml \
    --cache-directory .dotter/cache.system \
    deploy -f )

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
  source ${SYSTEM_DIR}/pico-fido/setup.sh
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

# plymouthd.conf (theme = abstract_ring) and the systemd-boot loader.conf were deployed earlier by the dotter system package
# the theme files are now in place too, so the initramfs below picks up the right theme.
echo "Injecting plymouth hook into /etc/mkinitcpio.conf (if missing)"
sudo bash -c "grep -q 'HOOKS=.*plymouth' /etc/mkinitcpio.conf || { sed -i '/^HOOKS=/ s/udev/udev plymouth/' /etc/mkinitcpio.conf && mkinitcpio -P; }"

echo "Appending plymouth params to /etc/kernel/cmdline (if missing)"
sudo bash -c "grep -q 'quiet splash' /etc/kernel/cmdline || { sed -i 's|\$| quiet splash loglevel=3 rd.udev.log_level=3 vt.global_cursor_default=0 systemd.show_status=false|' /etc/kernel/cmdline && sudo mkinitcpio -P; }"

if [ "${NVIDIA}" = "true" ]; then
  source ${SYSTEM_DIR}/nvidia/setup.sh
fi
