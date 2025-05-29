#!/bin/bash

apt install -y \
    open-vm-tools \
    open-vm-tools-desktop \
    curl \
    wget \
    tmux \
    make \
    vim \
    software-properties-common

apt-add-repository --yes --update ppa:ansible/ansible

apt install -y \
    ansible
