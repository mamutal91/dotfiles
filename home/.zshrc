export ZSH="/home/mamutal91/.oh-my-zsh"

# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="robbyrussell"

plugins=(git archlinux extract web-search)

source $ZSH/oh-my-zsh.sh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

export TERM=xterm-256color
export EDITOR=nano
export LANG=pt_BR.UTF-8
export LC_ALL=pt_BR.UTF-8
export LANGUAGE=pt_BR.UTF-8
export LC_CTYPE=pt_BR.UTF-8

export BROWSER=firefox
export iconsnotify="/usr/share/icons/Paper/32x32/apps"

function push () {
 repo=${1}
 branch=${2}
 git push ssh://git@github.com/mamutal91/$repo HEAD:refs/heads/$branch --force
 git push ssh://git@github.com/KrakenProject/$repo HEAD:refs/heads/$branch --force
}
