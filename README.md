# Dotfiles

Repository to store my configuration files

## Requirements

Ensure you have the following installed on your system
```
$ paru -S git stow bat lsd starship zoxide fzf
```

## Installation

First, clone this repo in your $HOME directory
```
$ git clone git@github.com/gbPagano/.dotfiles
$ cd .dotfiles
```
Then use GNU stow to create symlinks
```
$ stow .
```