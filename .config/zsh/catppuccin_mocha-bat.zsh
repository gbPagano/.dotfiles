[ ! -d "$(bat --config-dir)/themes" ] && \
    mkdir -p "$(bat --config-dir)/themes" && \
    wget -P "$(bat --config-dir)/themes" https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Mocha.tmTheme && \
    bat cache --build