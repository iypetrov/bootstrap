#!/bin/bash

mkdir -p /projects/personal
mkdir -p /projects/work

# common
read -s -p "Vault password: " vault_pass
echo

git clone https://github.com/iypetrov/vault.git /projects/common/vault
find /projects/common/vault/.ssh -type f -exec ansible-vault decrypt --vault-password-file=<(echo "${vault_pass}") {} \;
find /projects/common/vault/auth_codes -type f -exec ansible-vault decrypt --vault-password-file=<(echo "${vault_pass}") {} \;

ln -sfn /projects/common/vault/.ssh /home/ipetrov
ln -sfn /projects/common/vault/auth_codes /home/ipetrov

git clone --branch universal-config-v2 git@github.com:iypetrov/.dotfiles.git /projects/common/.dotfiles
stow -t /home/ipetrov .

git clone git@github.com:iypetrov/books.git /projects/common/books

rm /tmp/vault_pass
