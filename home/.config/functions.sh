#!/usr/bin/env bash

source $HOME/.colors &>/dev/null

function dot() {
  if [[ ${1} ]]; then
    cd $HOME && rm -rf .dotfiles && git clone ssh://git@github.com/mamutal91/dotfiles .dotfiles && source $HOME/.zshrc
  else
    echo -e "${YEL}Wait, ${BLU}recloning dotfiles to have the latest changes...${END}"
    ssh mamutal91@86.109.7.111 "cd $HOME && rm -rf .dotfiles && git clone ssh://git@github.com/mamutal91/dotfiles .dotfiles && bash $HOME/.dotfiles/install.sh && source $HOME/.zshrc"
    ssh mamutal91@147.75.80.89 "cd $HOME && rm -rf .dotfiles && git clone ssh://git@github.com/mamutal91/dotfiles .dotfiles && bash $HOME/.dotfiles/install.sh && source $HOME/.zshrc"
  fi
}

function infra() {
  echo -e "${YEL}Wait, ${CYA}recloning infra to have the latest changes...${END}"
  ssh mamutal91@86.109.7.111 "cd $HOME && rm -rf /mnt/roms/infra && git clone ssh://git@github.com/AOSPK/infra /mnt/roms/infra"
}

function fetch() {
  $HOME/.config/scripts/fetch.sh gnu
}

function f() {
  org=$(echo ${1} | cut -c1-5)
  if [[ $org = AOSPK ]]; then
    git fetch ssh://git@github.com/${1} ${2}
  else
    git fetch https://github.com/${1} ${2}
  fi
}

function p() {
  git cherry-pick ${1}
}

function translate() {
  typing=$(mktemp)
  rm -rf $typing && nano $typing
  msg=$(trans -b :en -no-auto -i $typing)
  typing=$(cat $typing)
  echo -e "${BOL_RED}Message: ${YEL}${msg}${END}\n"
}

function gitpush() {
  pwdFolder=${PWD##*/}
  pwd=$(pwd | cut -c-24)

  blacklist(){
    [ $pwdFolder = manifest ] && echo "${BOL_RED}Blacklist detected, no push!!!${END}" && break &>/dev/null
  }

  if [[ $pwd = "/mnt/roms/jobs/KrakenDev" ]]; then
    echo "\n${BOL_RED}No push!${END}\n"
  else
    if [[ ${1} = force ]]; then
      echo -e "\n${BOL_YEL}Pushing with --force!${END}\n"
      blacklist
      git push -f
    else
      echo -e "\n${BOL_YEL}Pushing!${END}\n"
      blacklist
      git push
    fi
  fi

  [ $pwdFolder = .dotfiles ] && dot &>/dev/null && exit
  [ $pwdFolder = infra ] && infra &>/dev/null && exit
}

function cm() {
  if git diff-index --quiet HEAD --; then
      echo "${BOL_RED}There are no local changes... leaving...${END}" && break 2 &>/dev/null
  else
    translate
    if [[ ${1} ]]; then
      git add . && git commit --signoff --date "$(date)" --author "${1}" && gitpush
    else
      git add . && git commit --message "${msg}" --signoff --date "$(date)" --author "Alexandre Rangel <mamutal91@gmail.com>" && gitpush
    fi
  fi
}

function amend() {
  if [[ ${1} ]]; then
    git add . && git commit --amend --signoff --date "$(date)" --author "${1}" && gitpush force
  else
    git add . && git commit --amend --date "$(date)" && gitpush force
  fi
}

function update() {
  $HOME/.config/scripts/update.sh
}
