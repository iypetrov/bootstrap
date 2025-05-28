#!/bin/bash

mkdir -p /projects/personal
mkdir -p /projects/work

# common
git clone https://github.com/iypetrov/vault.git /projects/common/vault
find .ssh -type f -exec ansible-vault decrypt --ask-vault-pass {} \;
find auth_codes -type f -exec ansible-vault decrypt --ask-vault-pass {} \;
ln -sfn /projects/common/vault/.ssh /home/ipetrov/.ssh
ln -sfn /projects/common/vault/auth_codes /home/ipetrov/auth_codes

git clone --branch universal-config-v2 git@github.com:iypetrov/.dotfiles.git /projects/common/.dotfiles
stow -t /home/ipetrov .

git clone git@github.com:iypetrov/books.git /projects/common/books
