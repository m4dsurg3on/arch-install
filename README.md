# Arch Basic Install Commands-Scripts

```
# loadkeys de_CH-latin1
# timedatectl set-ntp true
# pacman -Syy
# reflector -c Czechia -a 6 --sort rate --save /etc/pacman.d/mirrorlist
# pacman -Syy
```

```
# lsblk
# gdisk /dev/sda
```

## gdisk

- 300M partition for **/boot** >> type is ef00
- create another partition for the **/root** by using the remaining size >> type is 8300

## Formating and mounting the created partitions for non-BTRFS

```
# lsblk
# mkfs.vfat /dev/sda1
# mkfs.ext4 /dev/sda2
```

```
# mount /dev/sda2 /mnt
# mkdir /mnt/boot
# mount /dev/sda1 /mnt/boot
```

## Formating and mounting the created partition for BTRFS

```
# lsblk
# mkfs.vfat /dev/sda1
# mkfs.btrfs /dev/sda2
```

```
# mount /dev/sda2 /mnt
# cd /mnt
# btrfs su cr @
# btrfs su cr @home
# btrfs su cr @snapshots
# btrfs su cr @var_log
# cd
# umount /mnt
# mount -o noatime,compress=zstd,space_cache=v2,subvol=@ /dev/sda2 /mnt
# mkdir /mnt/{boot,home,.snapshots,var/log}
# mount -o noatime,compress=zstd,space_cache=v2,subvol=@home /dev/sda2 /mnt/home
# mount -o noatime,compress=zstd,space_cache=v2,subvol=@snapshots /dev/sda2 /mnt/.snapshots
# mount -o noatime,compress=zstd,space_cache=v2,subvol=@var_log /dev/sda2 /mnt/var/log
# mount /dev/sda1 /mnt/boot
```

## Installing the base packages

`# pacstrap /mnt base linux linux-firmware git vim intel-ucode`

## Generating the partition table

```
# genfstab -U /mnt >> /mnt/etc/fstab
# cat /mnt/etc/fstab
```

`# arch-chroot /mnt`

```
# git clone https://gitlab.com/m4dsurg3on/arch-install
# cd /arch-install
# chmod +x base.sh
# cd /
# ./arch/install/base.sh
```

`# vim /etc/mkinitcpio.conf`
  add **btrfs** **nvidia** into **MODULES**
  remove **fsck** from **HOOKS**
  
`# mkinitcpio -p linux`

```
exit
umount -a
reboot
```

```
$ sudo umount /.snapshots
$ sudo rm -r /.snapshots
$ sudo snapper -c root create-config /
$ sudo btrfs subvolume delete /.snapshots
$ sudo mkdir /.snapshots
$ sudo mount -a
$ sudo chmod 750 /.snapshots
$ sudo chmod a+rx /.snapshots
$ sudo chown :sanjin /.snapshots
$ sudo vim /etc/snapper/configs/root
    ALLOW_USERS="sanjin"
    TIMELINE_MIN_AGE="1800"
    TIMELINE_LIMIT_HOURLY="5"
    TIMELINE_LIMIT_DAILY="7"
    TIMELINE_LIMIT_WEEKLY="0"
    TIMELINE_LIMIT_MONTHLY="0"
    TIMELINE_LIMIT_YEARLY="0"
```

```
$ sudo systemctl enable --now snapper-timeline.timer
$ sudo systemctl enable --now snapper-cleanup.timer
```

```
$ git clone https://aur.archlinux.org/yay.git
$ cd yay/
$ makepkg -si PKGBUILD
$ cd
$ yay -S snap-pack-grub snapper-gui ttf-ms-fonts
$ sudo mkdir /etc/pacman.d/hooks
$ sudo vim /etc/pacman.d/hooks/50-bootbackup.hook
    [Trigger]
    Operation = Upgrade
    Operation = Install
    Operation = Remove
    Type = Path
    Target = boot/*

    [Action]
    Depends = rsync
    Description = Backing up /boot...
    When = PostTransaction
    Exec = /usr/bin/rsync -a --delete /boot /.bootbackup
```

`RUN kde.sh`
