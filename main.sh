#!/bin/bash

set -euo pipefail

USERNAME="ipetrov"
read -rp "GitHub Username: " GH_USERNAME
read -srp "GitHub Personal Access Token: " GH_PAT
echo
read -srp "Ansible Vault Password: " ANSIBLE_VAULT_PASSWORD
echo

if [[ $EUID -ne 0 ]]; then
  echo "Please run as root (use sudo)"
  exit 1
fi

# Dependencies
apt update
apt install -y \
  open-vm-tools \
  open-vm-tools-desktop \
  curl \
  wget \
  git \
  unzip \
  zsh \
  stow \
  ansible \
  sudo \
  vim \
  tmux \
  fzf \
  build-essential \
  ripgrep \
  ca-certificates \
  openssh-client \
  make \
  software-properties-common \
  lazygit \
  silversearcher-ag

# User 
if ! id "$USERNAME" &>/dev/null; then
  useradd -m -s /bin/zsh "$USERNAME"
fi
usermod -aG sudo "$USERNAME"
echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" > "/etc/sudoers.d/$USERNAME"
chmod 0440 "/etc/sudoers.d/$USERNAME"

# Docker
curl -fsSl https://get.docker.com | sh
groupadd docker
usermod -aG docker "$USERNAME"
newgrp docker

# Setup projects
sudo -u "$USERNAME" bash << EOF
set -euo pipefail
chsh -s $(which zsh)
mkdir -p ~/projects/common ~/projects/personal ~/projects/work
echo "${ANSIBLE_VAULT_PASSWORD}" > /tmp/ansible-vault-pass.txt
git clone https://${GH_USERNAME}:${GH_PAT}@github.com/iypetrov/vault.git ~/projects/common/vault
find ~/projects/common/vault/.ssh -type f -exec ansible-vault decrypt --vault-password-file /tmp/ansible-vault-pass.txt {} \;
find ~/projects/common/vault/.aws -type f -exec ansible-vault decrypt --vault-password-file /tmp/ansible-vault-pass.txt {} \;
ln -sfn ~/projects/common/vault/.ssh ~/
ln -sfn ~/projects/common/vault/.aws ~/
git clone https://${GH_USERNAME}:${GH_PAT}@github.com/iypetrov/.dotfiles.git ~/projects/common/.dotfiles
cd ~/projects/common
stow .dotfiles
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
find ~/projects/common/vault/.ssh -type f -exec ansible-vault encrypt --vault-password-file /tmp/ansible-vault-pass.txt {} \;
find ~/projects/common/vault/.aws -type f -exec ansible-vault encrypt --vault-password-file /tmp/ansible-vault-pass.txt {} \;
rm /tmp/ansible-vault-pass.txt
EOF
