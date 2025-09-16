# Zsh Setup
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="minimal"
plugins=(git)
source $ZSH/oh-my-zsh.sh

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
