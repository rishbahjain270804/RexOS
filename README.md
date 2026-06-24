# RexOS

**A custom Linux desktop — your own OS identity on top of Arch + Hyprland.**

RexOS is a set of dotfiles + theme that turns a plain Arch Linux + Hyprland
install into *RexOS*: your wallpaper, your colors, your bar, your launcher, your
login screen. It runs real apps (browser, editors, anything), has a working
mouse and animations, and looks like a modern OS — because it builds on Linux
instead of fighting it.

## What's inside

```
rexos-linux/
├── theme/            the RexOS design system (colors, fonts)
├── hypr/             Hyprland window manager config (animations, keybinds, mouse)
├── waybar/           the RexOS top bar (clock, workspaces, system tray)
├── rofi/             the RexOS app launcher
├── wallpapers/       static RexOS wallpapers
├── live/             live (video) wallpapers — drop .mp4/.webm here
├── scripts/          rexos-wallpaper (the unified wallpaper engine)
├── sddm/             the RexOS login screen theme
├── install.sh        one command to set it all up on Arch
└── packages.txt      the apps RexOS ships with
```

## Wallpapers — static AND live

Press **Super+W** to open the wallpaper picker. RexOS supports three kinds:

- **Static** images (.png/.jpg/.webp) — smooth transitions via swww
- **Live** video wallpapers (.mp4/.webm/.gif) — via mpvpaper. Drop files in
  `~/.local/share/rexos/live/`
- **Wallpaper Engine** scenes (like *Albedo's Paradise*) — via
  linux-wallpaperengine. Put scene folders in `~/.local/share/rexos/wallengine/`

Add as many as you want — they all show up in the **Super+W** picker. See
[live/README.md](live/README.md) for how to add live wallpapers.

## The RexOS identity

- **Name:** RexOS
- **Accent:** a deep teal/cyan (`#14b8c4`) — the RexOS signature color
- **Background:** deep indigo → violet gradient
- **Feel:** clean, modern, minimal — polished, not cluttered

## Install (on an Arch + Hyprland system)

```bash
git clone <your-repo> rexos
cd rexos
./install.sh
```

## Built on

- **Arch Linux** — lightweight, rolling, fully customizable
- **Hyprland** — modern Wayland compositor with animations + real mouse support
- **Waybar, Rofi, SDDM** — bar, launcher, login

This is the realistic path to "my own OS": your design and identity on a
foundation that actually runs real software.
