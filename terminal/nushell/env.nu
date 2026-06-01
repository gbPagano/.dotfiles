# Environment variables and PATH

$env.EDITOR = "nvim"

# zoxide: silence the `doctor` warning
$env._ZO_DOCTOR = "0"

# LS_COLORS: nushell's builtin `ls` (and lsd) color filenames from this var.
# zsh inherits it from the system (grml /etc/zsh/zshrc runs dircolors), but a
# login nushell does not, so generate the default database ourselves. Without it
# `ls` falls back to mismatched colors.
$env.LS_COLORS = (
    ^dircolors
    | lines
    | first
    | str replace "LS_COLORS='" ""
    | str replace "';" ""
)

$env.PATH = (
    $env.PATH
    | split row (char esep)
    | append ($nu.home-dir | path join ".local" "bin")
    | append ($nu.home-dir | path join ".cargo" "bin")
    | uniq
)

# fzf: read by the `fzf --nushell` integration generated into vendor/autoload.
# Mirrors terminal/fzf/fzf.sh (single quotes are kept so fzf parses them itself).
$env.FZF_DEFAULT_OPTS = "--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc --color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 --color=selected-bg:#45475a --preview-window=hidden --bind 'alt-p:toggle-preview'"
$env.FZF_DEFAULT_COMMAND = "fd --type f --strip-cwd-prefix --hidden --follow --exclude .git"
$env.FZF_CTRL_T_COMMAND = $env.FZF_DEFAULT_COMMAND
$env.FZF_CTRL_R_OPTS = "--height 20%"
$env.FZF_CTRL_T_OPTS = "--walker-skip .git,.venv,target --preview '~/.config/fzf/fzf-preview.sh {}' --preview-window=nohidden --height 40%"
$env.FZF_ALT_C_OPTS = "--walker-skip .git,.venv,target --preview-window=nohidden --preview 'tree -C {} | head -200' --height 20%"
