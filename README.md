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
sudo install -d -m 0700 /var/cache/dotter-system
sudo dotter --local-config .dotter/local.system.toml \
  --cache-file /var/cache/dotter-system/cache.toml \
  --cache-directory /var/cache/dotter-system/cache \
  --post-deploy .dotter/post_deploy.system.sh \
  deploy
```

Only the system package runs as root. Its cache lives under `/var/cache`, and
the no-op post-deploy prevents user-session commands from running as root.
