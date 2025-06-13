#!/bin/bash

read -rp "GitHub Personal Access Token: " GH_PAT
read -rp "Ansible Vault Password: " ANSIBLE_VAULT_PASSWORD

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

# setup
rm -rf /root/.bashrc
rm -rf /root/.ssh
rm -rf /root/.tmux/plugins/tpm
git clone https://github.com/tmux-plugins/tpm /root/.tmux/plugins/tpm
mkdir -p /root/projects/common /root/projects/personal /root/projects/ip812 /root/projects/avalon /root/projects/work
echo "${ANSIBLE_VAULT_PASSWORD}" > /tmp/ansible-vault-pass.txt
git clone https://${GH_USERNAME}:${GH_PAT}@github.com/iypetrov/vault.git /root/projects/common/vault
find /root/projects/common/vault/.ssh -type f -exec ansible-vault decrypt --vault-password-file /tmp/ansible-vault-pass.txt {} \;
find /root/projects/common/vault/.aws -type f -exec ansible-vault decrypt --vault-password-file /tmp/ansible-vault-pass.txt {} \;
ln -sfn /root/projects/common/vault/.ssh /root
ln -sfn /root/projects/common/vault/.aws /root
git clone https://${GH_USERNAME}:${GH_PAT}@github.com/iypetrov/.dotfiles.git /root/projects/common/.dotfiles
cd /root/projects/common
stow --target=/root .dotfiles
git clone https://github.com/tmux-plugins/tpm /root/.tmux/plugins/tpm
cd /root/projects/common/vault
git remote set-url origin git@github.com:iypetrov/vault.git
cd /root/projects/common/.dotfiles
git remote set-url origin git@github.com:iypetrov/.dotfiles.git
rm /tmp/ansible-vault-pass.txt

# # common
# cd /root/projects/common
# git clone git@github.com:iypetrov/books.git
# 
# # personal
# cd /root/projects/personal
# git clone git@github.com:iypetrov/go-playground.git
# git clone git@github.com:iypetrov/aws-playground.git
# git clone git@github.com:iypetrov/k8s-playground.git
# git clone git@github.com:iypetrov/lambdas.git
# 
# # ip812
# cd /root/projects/ip812
# git clone git@github.com:ip812/infra.git
# git clone git@github.com:ip812/go-template.git
# git clone git@github.com:ip812/lambdas.git
# 
# # avalon
# cd /root/projects/avalon
# git clone git@github.com:avalonpharma/infra.git
# git clone git@github.com:avalonpharma/avalon-ui.git
# git clone git@github.com:avalonpharma/avalon-rest.git
# 
# # work
# CPX_USERNAME="ilia.petrov"
# CPX_PAT="$(cat /root/projects/common/vault/auth_codes/cpx-gitlab.txt)"
# cd /root/projects/work
# git clone https://$CPX_USERNAME:$CPX_PAT@innersource.soprasteria.com/ENER-GXrestricted/infrastructure/terraform/tf-de-gasx.git
# git clone https://$CPX_USERNAME:$CPX_PAT@innersource.soprasteria.com/ENER-GXrestricted/infrastructure/terraform/tf-de-lab52.git
# git clone https://$CPX_USERNAME:$CPX_PAT@innersource.soprasteria.com/ENER-GXrestricted/infrastructure/terraform/tf-de-lab12.git
# git clone https://$CPX_USERNAME:$CPX_PAT@innersource.soprasteria.com/ENER-GXrestricted/infrastructure/terraform/tf-de-lab09.git
# git clone https://$CPX_USERNAME:$CPX_PAT@innersource.soprasteria.com/ENER-GXrestricted/infrastructure/terraform/tf-ci-library.git
# git clone https://$CPX_USERNAME:$CPX_PAT@innersource.soprasteria.com/ENER-GXrestricted/infrastructure/salt/salt.git
# git clone https://$CPX_USERNAME:$CPX_PAT@innersource.soprasteria.com/ENER-GXrestricted/infrastructure/salt/pillar.git

git clone https://github.com/asdf-vm/asdf.git /root/.asdf --branch v0.11.0
echo ". \$HOME/.asdf/asdf.sh" >> /root/.bashrc
source /root/.bashrc
asdf plugin add delta
asdf plugin add nodejs
asdf plugin add python
asdf plugin add java
asdf plugin add golang
asdf plugin add awscli
asdf plugin add kubectl
asdf plugin add terraform
asdf install

# tmux
touch /root/.tmux/last_session

# docker
usermod -aG docker root
newgrp docker
