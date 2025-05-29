#!/bin/bash

function install_dep() {
    local cmd=$1
    
    if which "${cmd}" > /dev/null 2>&1; then
        echo "🔕 Skip isntalling ${cmd} dependency, already available"
    else
        if ! [[ -f "/var/log/deps/${cmd}.log" ]]; then
            touch "/var/log/deps/${cmd}.log"
        fi

        echo "🔧 Installing ${cmd} dependency"
        if apt install -y "${cmd}" > "/var/log/deps/${cmd}.log" 2>&1; then
            echo "✅ ${cmd} dependency installed successfully"
        else
            echo "❌ ${cmd} dependency failed to install"
        fi
    fi
}

mkdir -p /var/log/deps

install_dep open-vm-tools
install_dep open-vm-tools-desktop
install_dep curl
install_dep wget
install_dep tmux
install_dep make
install_dep vim
install_dep stow
install_dep software-properties-common
install_dep zsh

apt-add-repository --yes --update ppa:ansible/ansible

install_dep ansible
