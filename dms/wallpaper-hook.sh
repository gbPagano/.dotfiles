#!/usr/bin/env bash
# Dank Hooks: onWallpaperChanged
#   $1 = event name ("onWallpaperChanged")
#   $2 = path to the new wallpaper
# Renders the picked wallpaper through awww: sharp on the normal workspace, and a
# pre-blurred copy in the overview backdrop (a second awww instance, namespace
# "overview"). niri can't blur the backdrop itself (its background-effect blur
# only affects what's behind translucent surfaces), so we pre-blur it here.
# `--resize crop` matches DMS "Fill" (cover, cropping the overflow).
set -euo pipefail

wallpaper="$2"
cache_dir="${XDG_CACHE_HOME:-$HOME/.cache}/wallpaper-blur"
mkdir -p "$cache_dir"
blur="$cache_dir/$(basename "$wallpaper").png"

transition=(--transition-type fade --transition-duration 1.0)

# Sharp wallpaper on the normal workspace background.
awww img "${transition[@]}" --resize crop "$wallpaper"

# Pre-blurred copy for the overview backdrop, computed once per wallpaper and
# cached by name. Downscale first so the blur is cheap.
if [[ ! -f "$blur" ]]; then
    magick "$wallpaper" -resize 20% -blur 0x8 "$blur"
fi
# The backdrop is only visible inside the overview, so swap it instantly.
awww img --transition-type none --namespace overview --resize crop "$blur"
