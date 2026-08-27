# Dotfiles

My personal configuration files and system setup scripts.

## Quick Installation

```sh
git clone https://github.com/gbPagano/.dotfiles.git
cd .dotfiles
./setup.sh
```

The setup replaces any existing display manager (such as LightDM, GDM, SDDM,
or Ly) with greetd. The current graphical session is left running, and greetd
takes over after the next reboot.

> [!IMPORTANT]
> Before linking, create your machine-local config from the example:
> ```sh
> cp .dotter/local.example.toml .dotter/local.toml
> ```
> Edit `.dotter/local.toml` with your git identity. This file is not tracked by git.

## Updates

After editing any user dotfile, re-link with:
```sh
dotter deploy
```

To update the root-owned system config (under `/etc` and `/boot`):
```sh
dotter --local-config .dotter/local.system.toml \
  --cache-file .dotter/cache.system.toml \
  --cache-directory .dotter/cache.system \
  --pre-deploy .dotter/pre_deploy.system.sh \
  deploy
```

Dotter runs as the current user. The system pre-deploy hook requests `sudo`
only while provisioning protected targets under `/etc` and `/boot`.
