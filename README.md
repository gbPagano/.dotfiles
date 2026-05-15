# Dotfiles

My personal configuration files and system setup scripts.

## Quick Installation

```sh
git clone https://github.com/gbPagano/.dotfiles.git
cd .dotfiles
./setup.sh
```

> [!IMPORTANT]
> Before linking, create your `vars.toml` from the example:
> ```sh
> cp example-vars.toml vars.toml
> ```
> Edit `vars.toml` with your personal details. This file is not tracked by git.

## Updates

After updating any configuration files, run:
```sh
bombadil link
```
