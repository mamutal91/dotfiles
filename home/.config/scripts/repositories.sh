#!/usr/bin/env bash

rm -rf $HOME/AOSPK && mkdir -p $HOME/AOSPK
rm -rf $HOME/GitHub && mkdir -p $HOME/GitHub

cd $HOME

rm -rf $HOME/.scripttest

git clone ssh://git@github.com/mamutal91/myarch GitHub/myarch
git clone ssh://git@github.com/mamutal91/custom-rom GitHub/custom-rom
git clone ssh://git@github.com/mamutal91/zsh-history GitHub/zsh-history
git clone ssh://git@github.com/mamutal91/scripttest $HOME/.scripttest
