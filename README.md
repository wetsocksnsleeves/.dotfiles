# My Dotfiles

This repo consists of all my dotfiles. 🔥 Amazing nvim configuration. Tmux configurations and all that stuff.

# Table of contents

[Installation](#installation)
[Want your own?](#setting-up-your-own-repo)
[Overview](#overview)

# Installation

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
```

Done! You can now use the files.

# Setting up your own repo

Just like any old local repo to remote setup. You run:

```
config remote add origin <repo url>
```

And the first push, use the -u flag to set the upstream as the main branch:

```
config push -u origin main
```

This project is based of the method in this [Atlassian Blog](https://www.atlassian.com/git/tutorials/dotfiles)

# Overview

## What's being used

💤 Lazy.nvim the Package manager
📁 Neo-tree as File explorer
🔭 Telescope as File finder
🔔 Lua Line for Status bar
🤓 Completions and Docstrings
🌊 Kanagawa themed

## Lsps, Linters, and Formatters

- nvim-lspconfig controls the LSPs making sure they all work.
- Mason is a manager for LSPs, Linters, and Formatters. Easily download inside nvim.
- Mason-null-ls is to allow Mason and none-ls to work together
- None-ls is to make linters and formatters work.

### Note

Mason is useful but sometimes the package it installs is broken, so it's better to just install it our self with yarn.

**Yarn install these for default configuration:**

- pyright
- @tailwindcss/language-server
- prettier

## Key binds

| Function | Keymap |
| -------- | ------ |
| Item1    | Item1  |
