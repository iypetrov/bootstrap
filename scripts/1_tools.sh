#!/bin/bash

apt install -y \
    open-vm-tools \
    open-vm-tools-desktop \
    curl \
    wget \
    git \
    tmux \
    vim \
    stow

systemctl enable --now vmtoolsd
