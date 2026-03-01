---
name: nix-shell-deps
description: Use nix-shell -p to temporarily install and run tools that are not available locally. When any skill requires Python, Node, ffmpeg, or other tools, follow this skill's guidance to wrap execution with nix-shell instead of installing globally.
---

# nix-shell-deps

Temporarily install dependencies using nix-shell without polluting the local environment.

## Basic Pattern

Check if a tool exists before execution. If not, run with `nix-shell -p`:

```bash
# Single package
nix-shell -p <package> --run "<command>"

# Multiple packages
nix-shell -p pkg1 pkg2 pkg3 --run "<command>"
```

## Package Naming Conventions

| Type | nixpkgs name | Example |
|------|--------------|---------|
| General tools | as-is | `ffmpeg`, `jq`, `imagemagick` |
| Python | `python3Packages.<name>` | `python3Packages.requests` |
| Node | `nodePackages.<name>` | `nodePackages.prettier` |
| Haskell | `haskellPackages.<name>` | `haskellPackages.pandoc` |

## Finding Package Names

```bash
nix search nixpkgs <name>
```

## Examples

```bash
# PDF manipulation with pypdf
nix-shell -p python3Packages.pypdf --run "python script.py"

# Image conversion
nix-shell -p imagemagick --run "convert input.png output.jpg"

# Combining multiple tools
nix-shell -p ffmpeg imagemagick --run "ffmpeg -i video.mp4 frame.png && convert frame.png -resize 50% thumb.png"
```
