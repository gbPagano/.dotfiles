# oh my zsh and plugins configuration
export ZSH="$HOME/.oh-my-zsh"
[ ! -d $ZSH ] && \
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended --keep-zshrc

export OMZ_PLUGINS="$ZSH/custom/plugins"
[ ! -d $OMZ_PLUGINS ] && mkdir -p "$(dirname $OMZ_PLUGINS)"

[ ! -d "$OMZ_PLUGINS/zsh-autosuggestions" ] && \
    git clone https://github.com/zsh-users/zsh-autosuggestions "$OMZ_PLUGINS/zsh-autosuggestions"

[ ! -d "$OMZ_PLUGINS/zsh-completions" ] && \
    git clone https://github.com/zsh-users/zsh-completions "$OMZ_PLUGINS/zsh-completions"
fpath+=$OMZ_PLUGINS/zsh-completions/src

[ ! -d "$OMZ_PLUGINS/zsh-syntax-highlighting" ] && \
    git clone https://github.com/zsh-users/zsh-syntax-highlighting "$OMZ_PLUGINS/zsh-syntax-highlighting"

[ ! -d "$OMZ_PLUGINS/fzf-tab" ] && \
    git clone https://github.com/Aloxaf/fzf-tab "$OMZ_PLUGINS/fzf-tab"

plugins=(
    zsh-autosuggestions
    zsh-completions
    zsh-syntax-highlighting
    fzf-tab
)
source $ZSH/oh-my-zsh.sh

# cattpuccin theme
source "$HOME/.config/zsh/catppuccin_mocha.zsh"

# aliases
alias mkvenv="python -m venv .venv --prompt venv "
alias venv="source ./.venv/bin/activate"
alias bat="bat -Pn --theme='Catppuccin Mocha'" # with numbers
alias cat="bat -Pp --theme='Catppuccin Mocha'" # without numbers
alias icat="kitty +kitten icat"
alias ls="lsd"
alias tree="lsd --tree --depth 2"
alias cdtmp="cd $(mktemp -d)"

# path
export PATH=$PATH:$HOME/.local/bin:$HOME/.cargo/bin
export CDPATH=$HOME:$HOME/projects
export FLYCTL_INSTALL="$HOME/.fly"

# beautiful prompt with startship
eval "$(starship init zsh)"

# fzf configuration
source "$HOME/.config/fzf/fzf.sh"

# zoxide init
eval "$(zoxide init --cmd cd zsh)"
