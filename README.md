# Dotfiles

Repository to store my configuration files

## Requirements

Ensure you have the following installed on your system
```
$ paru -S git stow bat lsd starship zoxide fzf chafa fd oh-my-zsh-git
```

## Installation

First, clone this repo in your $HOME directory
```
$ git clone https://github.com/gbPagano/.dotfiles.git
$ cd .dotfiles
```
Then use GNU stow to create symlinks
```
$ stow .
```
