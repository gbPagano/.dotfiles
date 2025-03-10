#!/bin/bash
# Terminal environment setup script
# Installs and configures all terminal-related abilities and configurations

# Check if paru is installed
if ! command -v paru &> /dev/null; then
    echo "❌ Error: paru is not installed. Please install paru first."
    exit 1
fi

echo "🐚 Installing Zsh - shell"
echo "📟 Installing WezTerm - terminal emulator"
echo "🔍 Installing fzf - fuzzy finder"
echo "📄 Installing bat - better cat replacement"
echo "📂 Installing lsd - modern ls replacement"
echo "🚀 Installing starship - shell prompt"
echo "🧭 Installing zoxide - smarter cd command"
echo "🖼️ Installing chafa - terminal image viewer"
echo "🔎 Installing fd - modern find replacement"
paru -S --needed \
    zsh \
    wezterm \
    fzf \
    bat \
    lsd \
    starship \
    zoxide \
    fzf \
    chafa \
    fd

echo "Setting Zsh as default shell"
chsh -s /bin/zsh $USER

echo "Terminal environment setup complete!"
