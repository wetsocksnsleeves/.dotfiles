# Zsh Setup
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="minimal"
plugins=(git)
source $ZSH/oh-my-zsh.sh

# Paths
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Default configurations
#   - Add other configurations to the local file
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh

alias sz="source ~/.zshrc"
