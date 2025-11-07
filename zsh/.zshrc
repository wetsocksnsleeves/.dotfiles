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

# Default configurations
#   - Add other configurations to the local file
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh

alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
alias sz="source ~/.zshrc"
alias mknextpj="npx create-next-app@latest"
alias aenv="source .venv/bin/activate"
