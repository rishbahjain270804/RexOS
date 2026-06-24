#!/usr/bin/env bash
# RexOS automated installer for a VirtualBox VM (run from the Arch ISO live env).
#
# WARNING: this ERASES /dev/sda. Only run inside the RexOS VM.
#
# Usage (from the Arch ISO boot prompt, with internet up):
#   curl -L https://raw.githubusercontent.com/rishbahjain270804/RexOS/main/vm-install.sh -o i.sh
#   bash i.sh
set -e

DISK=/dev/sda
HOSTNAME=rexos
USERNAME=rex

echo "=============================="
echo "   RexOS automated installer"
echo "=============================="
echo "This will ERASE $DISK and install RexOS."
read -p "Type YES to continue: " ok
[ "$ok" = "YES" ] || { echo "aborted"; exit 1; }

read -p "Choose a password for user '$USERNAME': " -s PW; echo

# --- partition: 1 EFI (512M) + 1 root (rest) ---
echo "==> Partitioning $DISK..."
sgdisk -Z "$DISK"
sgdisk -n1:0:+512M -t1:ef00 -c1:EFI "$DISK"
sgdisk -n2:0:0     -t2:8300 -c2:ROOT "$DISK"

mkfs.fat -F32 "${DISK}1"
mkfs.ext4 -F "${DISK}2"

mount "${DISK}2" /mnt
mkdir -p /mnt/boot
mount "${DISK}1" /mnt/boot

# --- base system ---
echo "==> Installing base system (this takes a few minutes)..."
pacstrap /mnt base linux linux-firmware networkmanager sudo git vim

genfstab -U /mnt >> /mnt/etc/fstab

# --- configure inside chroot ---
cat > /mnt/root/setup.sh <<CHROOT
#!/bin/bash
set -e
ln -sf /usr/share/zoneinfo/UTC /etc/localtime
hwclock --systohc
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf
echo "$HOSTNAME" > /etc/hostname

# bootloader (systemd-boot, simple for UEFI)
bootctl install
cat > /boot/loader/loader.conf <<L
default rexos
timeout 1
L
ROOT_UUID=\$(blkid -s PARTUUID -o value ${DISK}2)
cat > /boot/loader/entries/rexos.conf <<E
title   RexOS
linux   /vmlinuz-linux
initrd  /initramfs-linux.img
options root=PARTUUID=\$ROOT_UUID rw
E

# user
useradd -m -G wheel "$USERNAME"
echo "$USERNAME:$PW" | chpasswd
echo "root:$PW" | chpasswd
echo "%wheel ALL=(ALL:ALL) ALL" > /etc/sudoers.d/wheel

systemctl enable NetworkManager

# --- install RexOS desktop as the user ---
su - "$USERNAME" -c '
  cd ~
  git clone https://github.com/rishbahjain270804/RexOS.git
  cd RexOS
  chmod +x install.sh
  ./install.sh
'
CHROOT

chmod +x /mnt/root/setup.sh
arch-chroot /mnt /root/setup.sh

echo
echo "=============================="
echo "  RexOS installed! Rebooting..."
echo "  Login: $USERNAME / (your password)"
echo "=============================="
umount -R /mnt
reboot
