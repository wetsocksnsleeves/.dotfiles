# Zsh Setup
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="minimal"
plugins=(git)
source $ZSH/oh-my-zsh.sh

# Vim keymaps
bindkey -v
bindkey -v 'jl' vi-cmd-mode

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

# Paths
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

FNM_PATH="/home/ecto/.local/share/fnm"
if [ -d "$FNM_PATH" ]; then
  export PATH="/home/ecto/.local/share/fnm:$PATH"
  eval "`fnm env`"
fi

# Default configurations
#   - Add other configurations to the local file
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh

alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
alias sz="source ~/.zshrc"
alias mknextpj="npx create-next-app@latest"
alias aenv="source .venv/bin/activate"

. "$HOME/.local/bin/env"

# pnpm
export PNPM_HOME="/home/ecto/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
