#!/bin/bash
# Install and configures all dependencies

SCRIPT_DIR=$(dirname "$0")

echo "====================================="
echo "📦 Setting up Paru AUR helper"
echo "====================================="
if ! command -v paru &> /dev/null; then
    echo "🔧 Installing dependencies..."
    sudo pacman -S --needed --noconfirm base-devel

    TEMP_DIR=$(mktemp -d)
    echo "📂 Created temporary directory: ${TEMP_DIR}"

    echo "📥 Cloning paru-bin repository..."
    git clone https://aur.archlinux.org/paru-bin.git "${TEMP_DIR}/paru-bin"

    echo "🔨 Building and installing paru..."
    cd "${TEMP_DIR}/paru-bin"
    makepkg -si --noconfirm

    echo "🧹 Cleaning up..."
    rm -rf "${TEMP_DIR}"

    if command -v paru &> /dev/null; then
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


echo "====================================="
echo "🔧 Installing Kanata keyboard remapper"
echo "====================================="
source ${SCRIPT_DIR}/kanata/setup.sh


echo "====================================="
echo "🖥️ Installing Neovim editor"
echo "====================================="
paru -S --needed neovim


echo "====================================="
echo "🖥️ Setting up terminal environment"
echo "====================================="
source ${SCRIPT_DIR}/configs/terminal/setup.sh


echo "====================================="
echo "🔗 Installing toml-bombadil dotfile manager"
echo "====================================="
paru -S --needed --noconfirm toml-bombadil


echo "====================================="
echo "🔗 Linking dotfiles with bombadil"
echo "====================================="
bombadil install "${SCRIPT_DIR}"
bombadil link

echo "====================================="
echo "✅ Dotfiles installation complete!"
echo "====================================="
