#!/usr/bin/env bash

source $HOME/.Xcolors &> /dev/null

icon="$HOME/.config/assets/icons/backup.png"

dunstify -i $icon "GitCron" "Starting backups..." &> /dev/null

clear

# My history
if [[ $(cat /etc/hostname) == odin ]]; then
  pwd=$(pwd)
  cd $HOME/GitHub/myhistory
  cp -rf $HOME/.zsh_history $HOME/GitHub/myhistory
  status=$(git add . -n)
  if [[ -n $status   ]]; then
    echo -e "${BOL_GRE}Copying .zsh_history${END}"
    m="Autocommit Git-Cron"
    git add .
    git commit -m "${m}" --signoff --author "Alexandre Rangel <mamutal91@aospk.org>" --date "$(date)"
    git push
  fi
  cd $pwd
  echo "${BOL_MAG}Copying ${BOL_RED}$HOME ${BOL_MAG}to ${BOL_GRE}/mnt/storage/mamutal91${END}"
  rm -rf $HOME/.cache
  mkdir -p /mnt/storage/mamutal91
  sudo cp -rf /home/mamutal91/.* /mnt/storage/mamutal91
fi

# Kraken
if [[ $(cat /etc/hostname) == mamutal91-v2 ]]; then
  m="Autocommit Git-Cron"
  pwd=$(pwd)
  sudo rm -rf /home/mamutal91/.gerrit
  git clone ssh://git@github.com/AOSPK/gerrit -b backup /home/mamutal91/.gerrit
  cp -rf /mnt/roms/sites/docker/gerrit /home/mamutal91/.gerrit
  cd /home/mamutal91/.gerrit
  git config --global user.email "bot@aospk.org" && git config --global user.name "Kraken Project Bot"
  git add . && git commit -m "${m}" --signoff --author "Kraken Project Bot <bot@aospk.org>" --date "$(date)" && git push -f
  git config --global user.email "mamutal91@aospk.org" && git config --global user.name "Alexandre Rangel"
  cd $pwd
fi
