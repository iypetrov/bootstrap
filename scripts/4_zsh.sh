#!/bin/bash

mkdir -p ~/.local/share/fonts
cd ~/.local/share/fonts
wget https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip
unzip JetBrainsMono.zip
fc-cache -fv

rm -rf JetBrainsMono.zip
rm -rf JetBrainsMono

apt install -y zsh
exit
chsh -s $(which zsh)
