#!/bin/bash

apt install -y \
    curl \
    wget \
    tmux \
    vim \
    stow \
    software-properties-common

apt-add-repository --yes --update ppa:ansible/ansible

apt install -y \
    ansible
