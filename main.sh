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
  bat \
  silversearcher-ag \
  jq \
  yq

# User 
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
stow --target=/home/$USERNAME/.dotfiles
git clone https://github.com/tmux-plugins/tpm /home/$USERNAME/.tmux/plugins/tpm
cd /home/$USERNAME/projects/common/vault
git remote set-url origin git@github.com:iypetrov/vault.git
cd /home/$USERNAME/projects/common/.dotfiles
git remote set-url origin git@github.com:iypetrov/.dotfiles.git
rm /tmp/ansible-vault-pass.txt

# common
cd /home/$USERNAME/projects/common
git clone git@github.com:iypetrov/books.git

# personal
cd /home/$USERNAME/projects/personal
git clone git@github.com:iypetrov/go-playground.git
git clone git@github.com:iypetrov/aws-playground.git
git clone git@github.com:iypetrov/k8s-playground.git
git clone git@github.com:iypetrov/lambdas.git

# ip812
cd /home/$USERNAME/projects/ip812
git clone git@github.com:ip812/infra.git
git clone git@github.com:ip812/go-template.git
git clone git@github.com:ip812/lambdas.git

# avalon
cd /home/$USERNAME/projects/avalon
git clone git@github.com:avalonpharma/infra.git
git clone git@github.com:avalonpharma/avalon-ui.git
git clone git@github.com:avalonpharma/avalon-rest.git

# work
CPX_USERNAME="ilia.petrov"Add commentMore actions
CPX_PAT="$(cat /home/$USERNAME/projects/common/vault/auth_codes/cpx-gitlab.txt)"
cd /home/$USERNAME/projects/work
git clone https://$CPX_USERNAME:$CPX_PAT@innersource.soprasteria.com/ENER-GXrestricted/infrastructure/terraform/tf-de-gasx.git
git clone https://$CPX_USERNAME:$CPX_PAT@innersource.soprasteria.com/ENER-GXrestricted/infrastructure/terraform/tf-de-lab52.git
git clone https://$CPX_USERNAME:$CPX_PAT@innersource.soprasteria.com/ENER-GXrestricted/infrastructure/terraform/tf-de-lab12.git
git clone https://$CPX_USERNAME:$CPX_PAT@innersource.soprasteria.com/ENER-GXrestricted/infrastructure/terraform/tf-de-lab09.git
git clone https://$CPX_USERNAME:$CPX_PAT@innersource.soprasteria.com/ENER-GXrestricted/infrastructure/terraform/tf-ci-library.git
git clone https://$CPX_USERNAME:$CPX_PAT@innersource.soprasteria.com/ENER-GXrestricted/infrastructure/salt/salt.git
git clone https://$CPX_USERNAME:$CPX_PAT@innersource.soprasteria.com/ENER-GXrestricted/infrastructure/salt/pillar.git

git clone https://github.com/asdf-vm/asdf.git /home/$USERNAME/.asdf --branch v0.11.0
asdf plugin add delta
asdf plugin add nodejs
asdf plugin add python
asdf plugin add java
asdf plugin add golang
asdf plugin add awscli
asdf plugin add kubectl
asdf plugin add terraform
asdf install
EOF

# tmux
touch /home/$USERNAME/.tmux/last_session

# docker
usermod -aG docker "$USERNAME"
newgrp docker
