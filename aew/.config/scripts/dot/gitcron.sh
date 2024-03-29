#!/usr/bin/env bash

source $HOME/.Xconfigs # My general configs

icon="$HOME/.config/assets/icons/backup.png"

dunstify -i $icon "GitCron" "Starting backups..."

clear

# My history
pwd=$(pwd)
  cd $HOME/GitHub/myhistory
  cp -rf $HOME/.zsh_history $HOME/GitHub/myhistory
  status=$(git add . -n)
  if [[ -n $status   ]]; then
    echo -e "${BOL_GRE}Copying .zsh_history${END}"
    c=$(echo $(git add . -n | tr '\r\n' ' '))
    m="Autocommit Git-Cron: changes: $c"
    git add .
    git commit -m "${m}" --signoff --author "Alexandre Rangel <mamutal91@gmail.com>" --date "$(date)"
    git push
  fi
cd $pwd

pwd=$(pwd)
  cd $HOME/GitHub/mywifi
  sudo cp -rf /var/lib/iwd $HOME/GitHub/mywifi
  sudo chmod 777 -R $HOME/GitHub/mywifi/iwd
  rm -rf $HOME/GitHub/mywifi/iwd/hotspot
  rm -rf $HOME/GitHub/mywifi/iwd/.known_network.freq
  status=$(git add . -n)
  if [[ -n $status   ]]; then
    echo -e "${BOL_GRE}Copying wifis${END}"
    c=$(echo $(git add . -n | tr '\r\n' ' '))
    m="Autocommit Git-Cron: changes: $c"
    git add .
    git commit -m "${m}" --signoff --author "Alexandre Rangel <mamutal91@gmail.com>" --date "$(date)"
    git push
  fi
cd $pwd
