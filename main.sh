#!/bin/bash

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
  curl \
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
  docker.io \
  silversearcher-ag

# User 
if ! id "$USERNAME" &>/dev/null; then
  useradd -m -s /bin/zsh "$USERNAME"
fi
usermod -aG sudo "$USERNAME"
echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" > "/etc/sudoers.d/$USERNAME"
chmod 0440 "/etc/sudoers.d/$USERNAME"

# Setup projects
sudo -u "$USERNAME" bash << EOF
# setup
rm -rf /home/$USERNAME/.ssh
rm -rf /home/$USERNAME/.tmux/plugins/tpm
git clone https://github.com/tmux-plugins/tpm /home/$USERNAME/.tmux/plugins/tpm
mkdir -p /home/$USERNAME/projects/common /home/$USERNAME/projects/personal /home/$USERNAME/projects/ip812 /home/$USERNAME/projects/avalon /home/$USERNAME/projects/work
echo "${ANSIBLE_VAULT_PASSWORD}" > /tmp/ansible-vault-pass.txt
git clone https://${GH_USERNAME}:${GH_PAT}@github.com/iypetrov/vault.git /home/$USERNAME/projects/common/vault
find /home/$USERNAME/projects/common/vault/.ssh -type f -exec ansible-vault decrypt --vault-password-file /tmp/ansible-vault-pass.txt {} \;
find /home/$USERNAME/projects/common/vault/.aws -type f -exec ansible-vault decrypt --vault-password-file /tmp/ansible-vault-pass.txt {} \;
ln -sfn /home/$USERNAME/projects/common/vault/.ssh /home/$USERNAME
ln -sfn /home/$USERNAME/projects/common/vault/.aws /home/$USERNAME
git clone https://${GH_USERNAME}:${GH_PAT}@github.com/iypetrov/.dotfiles.git /home/$USERNAME/projects/common/.dotfiles
cd /home/$USERNAME/projects/common
stow --target=/home/ipetrov .dotfiles
git clone https://github.com/tmux-plugins/tpm /home/$USERNAME/.tmux/plugins/tpm
find /home/$USERNAME/projects/common/vault/.ssh -type f -exec ansible-vault encrypt --vault-password-file /tmp/ansible-vault-pass.txt {} \;
find /home/$USERNAME/projects/common/vault/.aws -type f -exec ansible-vault encrypt --vault-password-file /tmp/ansible-vault-pass.txt {} \;
rm /tmp/ansible-vault-pass.txt

# common
# personal
# ip812
# avalon
# work
EOF

# tmux
touch "/home/$USERNAME/.tmux/last_session"

# zsh
chsh -s "$(which zsh)" "$USERNAME"

# docker
usermod -aG docker "$USERNAME"
newgrp docker
