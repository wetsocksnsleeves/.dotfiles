# Zsh Setup
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="minimal"
plugins=(git)
source $ZSH/oh-my-zsh.sh

# Vim keymaps
bindkey -v
bindkey -v 'fd' vi-cmd-mode

# Visual cursor indicator
function zle-keymap-select() {
  case $KEYMAP in
    vicmd)      echo -ne '\e[2 q' ;;
    viins|main) echo -ne '\e[6 q' ;;
  esac
}
zle -N zle-keymap-select

zle-line-init() {
  echo -ne '\e[6 q'
}
zle -N zle-line-init

# pnpm
export PNPM_HOME="/home/ecto/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# Default configurations; Put local configs in .zshrc.local
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh

# opencode
export PATH=/home/ecto/.opencode/bin:$PATH

eval "$(zoxide init zsh)"
. "$HOME/.local/share/../bin/env"

alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
alias sz="source ~/.zshrc"
alias mknextpj="npx create-next-app@latest"
alias aenv="source .venv/bin/activate"
alias dex="find /usr/share/applications ~/.local/share/applications -name '*.desktop' | fzf | xargs sudo nvim"
alias lgit="lazygit"
