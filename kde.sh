#!/bin/bash

sudo timedatectl set-ntp true
sudo hwclock --systohc

# Optional ZRAMD package for the SWAP https://wiki.archlinux.org/title/Improving_performance#zram_or_zswap
# yay -S zramd

sudo reflector -c Czechia -a 6 --sort rate --save /etc/pacman.d/mirrorlist
sudo pacman -Syy

sudo pacman -S --noconfirm xorg sddm plasma kde-applications firefox libreoffice vlc materia-kde papirus-icon-theme

sudo systemctl enable sddm
# sudo systemctl enable --now zramd.service
