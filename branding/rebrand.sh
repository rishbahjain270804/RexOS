#!/usr/bin/env bash
# RexOS rebrand — makes the system identify as RexOS, not Arch/Hyprland.
# Run as ROOT (the installer calls it). Safe to re-run.
set -e
B="$(cd "$(dirname "$0")" && pwd)"

echo "==> Rebranding system as RexOS..."

# 1. /etc/os-release  -> neofetch/fastfetch/login show "RexOS"
cp "$B/os-release" /etc/os-release
# keep a real arch-release too so pacman/AUR stay happy, but lsb shows RexOS
[ -f /etc/arch-release ] && echo "RexOS" > /etc/lsb-release 2>/dev/null || true
cat > /etc/lsb-release <<L
DISTRIB_ID=RexOS
DISTRIB_RELEASE=1.0
DISTRIB_DESCRIPTION="RexOS"
L

# 2. issue / motd (the text-login banner says RexOS)
printf '\n  \\e[38;2;20;184;196mRexOS\\e[0m  \\r (\\l)\n\n' > /etc/issue
cat > /etc/motd <<M

  Welcome to RexOS - the from-scratch operating system.

M

# 3. bootloader entry title -> "RexOS" (hide "Arch")
if [ -f /boot/loader/entries/rexos.conf ]; then
    sed -i 's/^title.*/title   RexOS/' /boot/loader/entries/rexos.conf
fi
# remove any arch-named loader entries
rm -f /boot/loader/entries/arch.conf 2>/dev/null || true

# 4. rename the Hyprland wayland session -> "RexOS" (so the login session
#    list + 'echo $XDG_CURRENT_DESKTOP' say RexOS, not Hyprland)
if [ -f /usr/share/wayland-sessions/hyprland.desktop ]; then
    cp /usr/share/wayland-sessions/hyprland.desktop /usr/share/wayland-sessions/rexos.desktop
    sed -i 's/^Name=.*/Name=RexOS/;        s/^Comment=.*/Comment=RexOS desktop/' \
        /usr/share/wayland-sessions/rexos.desktop
    sed -i 's/^DesktopNames=.*/DesktopNames=RexOS/' /usr/share/wayland-sessions/rexos.desktop || \
        echo "DesktopNames=RexOS" >> /usr/share/wayland-sessions/rexos.desktop
    # hide the original Hyprland entry from the session picker
    rm -f /usr/share/wayland-sessions/hyprland.desktop
fi

# 5. fastfetch as the RexOS branding (also alias neofetch -> fastfetch)
echo "==> RexOS rebrand complete."
