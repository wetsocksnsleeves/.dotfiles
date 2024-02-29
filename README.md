# Ecto's Dotfiles

This repo consists of all my dotfiles, mainly used for myself to track my
configurations across devices.

### Installation 
First, commit the corosponding aliases to your .bashrc or .zsh:  
```
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
```

Then, you run the following to prevent recursion errors:  
```
echo ".cfg" >> .gitignor
```

Clone this repo:  
```
git clone --bare git@github.com:realecto/.dotfiles.git $HOME/.cfg
```

Define the aliases in the current shell scope:  
```
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
```

Checkout the repo content:  
```
config checkout
```

If there are issues, resolve them with the commandline output.  

Then set the config tag to ignore untracked files:  
```
config config --local status.showUntrackedFiles no
````

Done! You can now use the files.

### Setting up your own repo
Just like any old local repo to remote setup. You run:  
```
config remote add origin <repo url>
```

And the first push, use the -u flag to set the upstream as the main branch:  
```
config push -u origin main
```



This project is based of the method in this [Atlassian Blog](https://www.atlassian.com/git/tutorials/dotfiles)
