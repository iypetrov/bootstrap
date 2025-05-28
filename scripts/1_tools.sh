#!/bin/bash

apt install -y \
    open-vm-tools \
    open-vm-tools-desktop \
    curl \
    wget \
    tmux \
    vim \
    stow

systemctl enable --now vmtoolsd
