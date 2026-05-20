#!/bin/bash
# Configures NVIDIA kernel modules for proper DRM/KMS support

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

REBUILD=0

blue_echo "=========================="
blue_echo "Configuring NVIDIA drivers"
blue_echo "=========================="

if grep -q 'options nvidia_drm modeset=1' /etc/modprobe.d/nvidia.conf 2>/dev/null; then
  echo "nvidia_drm modeset already set in /etc/modprobe.d/nvidia.conf"
else
  echo "Writing /etc/modprobe.d/nvidia.conf"
  run sudo bash -c 'echo "options nvidia_drm modeset=1" > /etc/modprobe.d/nvidia.conf'
  REBUILD=1
fi

if grep -q 'nvidia_drm' /etc/mkinitcpio.conf 2>/dev/null; then
  echo "NVIDIA modules already present in /etc/mkinitcpio.conf"
else
  echo "Injecting nvidia modules into MODULES array in /etc/mkinitcpio.conf"
  run sudo sed -i '/^MODULES=/ s/)$/ nvidia nvidia_modeset nvidia_uvm nvidia_drm)/' /etc/mkinitcpio.conf
  REBUILD=1
fi

if [ "$REBUILD" -eq 1 ]; then
  run sudo mkinitcpio -P
fi

green_echo "=============================="
green_echo "NVIDIA configuration complete!"
green_echo "=============================="
