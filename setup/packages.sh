#!/usr/bin/env bash

# Dependencies for dotfiles
dependencies=(
  pulseaudio alsa-firmware alsa-utils alsa-plugins pulseaudio pulseaudio-bluetooth pavucontrol sox
  bluez bluez-libs bluez-tools bluez-utils

  i3-gaps i3lock feh rofi dunst picom polybar alacritty stow nano nano-syntax-highlighting neofetch vlc gpicview zsh zsh-syntax-highlighting oh-my-zsh-git maim ffmpeg imagemagick slop
  thunar thunar-archive-plugin thunar-media-tags-plugin thunar-volman

  flatery-icon-theme-git vimix-cursors dracula-gtk-theme

  google-chrome kotatogram-desktop-bin

  terminus-font noto-fonts-emoji ttf-dejavu ttf-liberation ttf-icomoon-feather ttf-font-awesome

  xorg-server xorg-xrandr xorg-xbacklight xorg-xinit xorg-xprop xorg-server-devel xorg-xsetroot xclip xsel xautolock xidlehook xorg-xdpyinfo xgetres
)

# My perosnal packages!!!
mypackages=(
  archlinux-keyring cronie

  nvidia nvidia-utils nvidia-settings nvidia-utils nvidia-dkms nvidia-prime opencl-nvidia nbfc-git
  mesa mesa-demos vulkan-tools lib32-nvidia-utils lib32-opencl-nvidia lib32-virtualgl lib32-nvidia-utils lib32-libvdpau lib32-opencl-nvidia lib32-mesa
  steam wine winetricks lib32-gnutls

  atom discord diff-so-fancy filezilla git htop jdk-openjdk jq krita man man-pages-pt_br github-cli-git gitlab-glab-bin
  rsync shfmt tree transmission-gtk zip translate-shell-git

  android-tools hfsprogs gvfs gvfs-mtp btrfs-progs dosfstools exfat-utils f2fs-tools e2fsprogs jfsutils nilfs-utils ntfs-3g reiserfsprogs udftools xfsprogs ntfs-3g

  openssh python-setuptools sbc unrar unzip wget

  qemu virt-manager virt-viewer dnsmasq vde2 bridge-utils openbsd-netcat libguestfs

  spotify-snap

  python-ruamel-yaml
  selinux-python
  laptop-mode-tools acpi
)
