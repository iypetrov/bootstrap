#!/bin/bash

mkdir -p /projects/personal
mkdir -p /projects/work

# common
git clone https://github.com/iypetrov/vault.git /projects/common/vault
ansible-vault decrypt /projects/common/vault/*   
stow -t /home/$(whoami) .

git clone git@github.com:iypetrov/.dotfiles.git /projects/common/.dotfiles
git clone git@github.com:iypetrov/books.git /projects/common/books
