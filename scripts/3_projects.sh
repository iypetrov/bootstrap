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

git clone --branch universal-config-v2 https://github.com/iypetrov/.dotfiles.git /projects/common/.dotfiles
ln -sfn /projects/common/.dotfiles /projects/common

git -C /projects/common/vault remote set-url origin git@github.com:iypetrov/vault.git
git -C /projects/common/.dotfiles remote set-url origin git@github.com:iypetrov/.dotfiles.git

git clone git@github.com:iypetrov/books.git /projects/common/books
ln -sfn /projects/common/books /projects/common
