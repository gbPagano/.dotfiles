export FZF_DEFAULT_OPTS=" \
--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
--color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8"
export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_R_OPTS="--height 20%"
export FZF_CTRL_T_OPTS="
  --walker-skip .git,.venv,target
  --preview '~/.config/fzf/fzf-preview.sh {}'
  --bind 'ctrl-/:change-preview-window(hidden|)'
  --height 40%"
export FZF_ALT_C_OPTS="
  --walker-skip .git,.venv,target
  --preview 'tree -C {} | head -200'
  --height 20%"

zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:code*' fzf-preview '~/.config/fzf/fzf-preview.sh $realpath'

eval "$(fzf --zsh)"