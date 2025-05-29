#!/bin/bash

mkdir -p /projects/common
mkdir -p /projects/personal
mkdir -p /projects/work

# common
git clone https://github.com/iypetrov/vault.git /projects/common/vault
ln -sfn /projects/common/vault /projects/common

ansible-vault decrypt --ask-vault-pass /projects/common/vault/ansible-vault-pass.txt

find /projects/common/vault/.ssh -type f -exec ansible-vault decrypt --vault-password-file /projects/common/vault/ansible-vault-pass.txt {} \;
find /projects/common/vault/auth_codes -type f -exec ansible-vault decrypt --vault-password-file /projects/common/vault/ansible-vault-pass.txt {} \;

rm -rf /home/ipetrov/.ssh
ln -sfn /projects/common/vault/.ssh /home/ipetrov
ln -sfn /projects/common/vault/auth_codes /home/ipetrov

git clone https://github.com/iypetrov/.dotfiles.git /projects/common/.dotfiles
cd /projects/common
stow --target=/home/ipetrov .dotfiles
cd /home/ipetrov

git clone git@github.com:iypetrov/books.git /projects/common/books
