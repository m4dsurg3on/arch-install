#!/bin/bash

ln -sf /usr/share/zoneinfo/Europe/Prague /etc/localtime
hwclock --systohc
sed -i '177s/.//' /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" >> /etc/locale.conf
echo "KEYMAP=de_CH-latin1" >> /etc/vconsole.conf
echo "arch" >> /etc/hostname
echo "127.0.0.1 localhost" >> /etc/hosts
echo "::1 localhost" >> /etc/hosts
echo "127.0.1.1 arch.localdomain arch" >> /etc/hosts
echo root:password | chpasswd

# EXT4 file system
# pacman -S grub efibootmgr os-prober networkmanager network-manager-applet dialog wpa_supplicant mtools dosfstools ntfs-3g reflector base-devel linux-headers xdg-utils xdg-user-dirs inetutils bluez bluez-utils pulseaudio-bluetooth bash-completion rsync

# BTRFS file system
pacman -S grub grub-btrfs efibootmgr os-prober btrfs-progs snapper networkmanager network-manager-applet dialog wpa_supplicant mtools dosfstools ntfs-3g reflector base-devel linux-headers xdg-utils xdg-user-dirs inetutils bluez bluez-utils pulseaudio-bluetooth bash-completion rsync

# NVIDIA video drivers
pacman -S --noconfirm nvidia nvidia-utils nvidia-settings

# VMware video drivers and tools
# pacman -S --noconfirm xf86-video-vmware xf86-input-vmmouse open-vm-tools

# Grub installation on the MSI motherboards
grub-install --target=x86_64-efi --efi-directory=/boot --removable

# Grub installation on the VM
# grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB

grub-mkconfig -o /boot/grub/grub.cfg

systemctl enable NetworkManager
systemctl enable bluetooth
systemctl enable reflector.timer
systemctl enable fstrim.timer
# systemctl enable vmtoolsd

useradd -m sanjin
echo sanjin:password | chpasswd
echo "sanjin ALL=(ALL) ALL" >> /etc/sudoers.d/sanjin

printf "\e[1;32mDone! Type exit, umount -a and reboot.\e[0m"
