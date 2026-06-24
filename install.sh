#!/usr/bin/env bash
# RexOS installer — turns an Arch Linux system into RexOS.
# Run on a fresh Arch install: ./install.sh
set -e

REXOS_DIR="$(cd "$(dirname "$0")" && pwd)"
CFG="$HOME/.config"

echo "  ____            ___  ____"
echo " |  _ \\ _____  __/ _ \\/ ___|"
echo " | |_) / _ \\ \\/ / | | \\___ \\   Installing RexOS..."
echo " |  _ <  __/>  <| |_| |___) |"
echo " |_| \\_\\___/_/\\_\\\\___/|____/"
echo

# 1. install packages
echo "==> Installing packages..."
sudo pacman -S --needed --noconfirm $(grep -vE '^\s*#|^\s*$' "$REXOS_DIR/packages.txt")

# 2. lay down configs
echo "==> Installing RexOS configs..."
mkdir -p "$CFG/hypr" "$CFG/waybar" "$CFG/rofi"

cp "$REXOS_DIR/theme/colors.conf"     "$CFG/hypr/colors.conf"
cp "$REXOS_DIR/hypr/hyprland.conf"    "$CFG/hypr/hyprland.conf"
cp "$REXOS_DIR/waybar/config.jsonc"   "$CFG/waybar/config.jsonc"
cp "$REXOS_DIR/waybar/style.css"      "$CFG/waybar/style.css"
cp "$REXOS_DIR/rofi/rexos.rasi"       "$CFG/rofi/rexos.rasi"

# wallpapers — static collection + folders for live (video) and engine scenes.
WALLDIR="$HOME/.local/share/rexos/wallpapers"
LIVEDIR="$HOME/.local/share/rexos/live"
WEDIR="$HOME/.local/share/rexos/wallengine"
mkdir -p "$WALLDIR" "$LIVEDIR" "$WEDIR" "$HOME/.local/bin"
cp "$REXOS_DIR/wallpapers/"* "$WALLDIR/" 2>/dev/null || true
cp "$REXOS_DIR/live/"* "$LIVEDIR/" 2>/dev/null || true

# install the unified RexOS wallpaper engine (static + video + wallpaper-engine)
cp "$REXOS_DIR/scripts/rexos-wallpaper" "$HOME/.local/bin/rexos-wallpaper"
chmod +x "$HOME/.local/bin/rexos-wallpaper"

# generate a sample LIVE wallpaper (animated RexOS gradient) so live works OOTB
if command -v ffmpeg >/dev/null && [ ! -f "$LIVEDIR/rexos-gradient-live.mp4" ]; then
    echo "==> Generating a sample live wallpaper..."
    ffmpeg -y -f lavfi -i "gradients=s=1920x1080:c0=0x1e2148:c1=0x3a2160:x0=0:y0=0:x1=1920:y1=1080:speed=0.01:duration=12" \
        -t 12 -pix_fmt yuv420p -loop 0 "$LIVEDIR/rexos-gradient-live.mp4" >/dev/null 2>&1 \
        && echo "   created rexos-gradient-live.mp4" || true
fi

# set the default wallpaper to the gradient on first install
"$HOME/.local/bin/rexos-wallpaper" set "$WALLDIR/rexos-wall.png" 2>/dev/null || true

# --- AUR: linux-wallpaperengine (for Steam Wallpaper Engine scenes) ---
echo "==> Installing AUR helper (yay) + linux-wallpaperengine..."
if ! command -v yay >/dev/null; then
    sudo pacman -S --needed --noconfirm git base-devel
    tmp=$(mktemp -d); git clone https://aur.archlinux.org/yay.git "$tmp/yay"
    ( cd "$tmp/yay" && makepkg -si --noconfirm )
fi
yay -S --needed --noconfirm linux-wallpaperengine-git jq || \
    echo "   (skip linux-wallpaperengine if it fails - video live wallpapers still work)"

# 3. login screen theme
echo "==> Installing RexOS login (SDDM)..."
if [ -d "$REXOS_DIR/sddm/rexos" ]; then
    sudo cp -r "$REXOS_DIR/sddm/rexos" /usr/share/sddm/themes/
    sudo mkdir -p /etc/sddm.conf.d
    echo -e "[Theme]\nCurrent=rexos" | sudo tee /etc/sddm.conf.d/rexos.conf >/dev/null
fi

# 4. enable services
echo "==> Enabling services..."
sudo systemctl enable sddm.service
sudo systemctl enable NetworkManager.service

echo
echo "==> RexOS installed! Reboot, and you'll boot into RexOS."
echo "    Super+R = launcher   Super+Return = terminal   Super+B = browser"
