#!/usr/bin/env bash
# github.com/mamutal91

clear

function boot() {
  cd $HOME/.config
  rm -rf alacritty gpicview mako neofetch sway waybar wofi mimeapps.list
  cd $HOME
  rm -rf .bashrc .bash_profile .zshrc .functions .nanorc
}

if [ "${1}" == "boot" ]; then boot; fi || echo "Error: boot"

cd $HOME/.dotfiles
for DOTFILES in \
  alacritty \
  gpicview \
  home \
  mako \
  neofetch \
  sway \
  waybar \
  wofi
do
    stow $DOTFILES || echo "Error on gnu/stow"
done

# Remove files from the system, and copy mine!
if [ "$USER" = "mamutal91" ];
then
  sudo stow -t /etc etc
#  source $HOME/.dotfiles/setup/etc.sh || echo "Error: etc"
fi

play $HOME/.bin/sounds/completed.wav
swaymsg reload
pkill waybar && exec waybar
exit 0
