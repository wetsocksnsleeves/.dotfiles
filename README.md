# My Dotfiles

Configurations I use to LARP as cracked so I eventually am cracked.

# Table of contents

[Installation](#installation)\
[Overview](#overview)\
[Keybinds](#key-binds)

# Installation

Install [fibre](https://github.com/wetsocksnsleeves/fibre):

```
curl -fsSL https://raw.githubusercontent.com/wetsocksnsleeves/fibre/main/install.sh | sh
```

Clone this repo to your home directory:

```
git clone git@github.com:wetsocksnsleeves/.dotfiles.git ~/.dotfiles
cd ~/.dotfiles
```

Each top-level directory is a fibre set, and its `fibre.yaml` says where it
links to. Link the sets you want, then start the watcher:

```
fibre link tmux
fibre link nvim
fibre link zsh
fibre watch install
```

Done! `fibre status` shows what each set links and anything that needs
attention.

| Machine | Sets |
|---|---|
| macOS | aerospace, claude, gh-dash, ghostty, herdr, lazygit, nvim, sesh, tmux, wallpapers, zsh |
| Linux | alacritty, davinci, hypr, i3, mako, omarchy, polybar, rofi, rofi-bin, sway, sway-bin, swaylock, waybar, waybar-bin, zsh-linux |
| Either | clang, opencode, ruby, tools, wezterm |

To track a new app's config, run `fibre init <name> --dest '$HOME/.config/<name>'`.
fibre moves the existing files into the set and links them back.

# Overview

### Note

**npm packages used:**

- eslint_d
- pyright
- prettier
- @tailwindcss/language-server
- typescript-language-server

## My ideal environment setup

1. Installing wget, curl, git, ripgrep, and zsh.
2. Installing Oh My Zsh. And apply my .zshrc
3. Install Neovim
4. Install Node.js, fnm, and pnpm
5. Install relevant npm [packages](#note)
6. mise
7. GNU gcc
11. Tmux
12. My dotfiles

## Key binds

[Neovim](#nvim)\
[Tmux](#tmux)

### Neovim

| Function                   | Keymap                                    |
| -------------------------- | ----------------------------------------- |
| space + gc                 | Comment line                              |
| space + gb                 | Block Comment                             |
| space + nf                 | Generate Docstring                        |
| space + gr                 | Find references                           |
| space + gd                 | Find definition                           |
| space + t                  | Go Back                                   |
| space + ca                 | Code action                               |
| space + rn                 | Rename                                    |
| K                          | Show hover information                    |
| ctrl + n                   | Open neo-tree                             |
| ctrl + h                   | Hide neo-tree                             |
| space + gf (or write file) | Format Code                               |
| ctrl + p                   | Open telescope                            |
| ctrl + c                   | Close telescope                           |
| space + fg                 | Live grep telescope                       |
| space + fb                 | Search for buffer                         |
| ctrl + p / Ctrl + n        | Next/Previous in telescope                |
| space + en                 | Telescope in nvim configuration folder    |
| z=                         | Vim spell correct suggestions             |
| space + fr                 | Find and replace                          |
| space + nh                 | Un-highlight                              |
| space + fx                 | Turn current file into executable         |
| F5                         | Run current python script                 |
| space + p                  | Paste without resetting default register  |
| space + y/yy               | Yank into system clipboard                |
| space + d/dd               | Delete without resetting default register |
| K / J                      | Move selection up and down                |

### Tmux

Mostly stock settings.

Leader is remapped to <ctrl + s>

| Function        | Keymap                      |
| --------------- | --------------------------- |
| leader + %      | Create pane to the right    |
| leader + "      | Create pane below           |
| leader + c      | Create new window           |
| leader + number | Move to window number       |
| leader + ,      | Rename window               |
| leader + d      | Detach from current session |
| leader + [      | Enter copy mode             |
