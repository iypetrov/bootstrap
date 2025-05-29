#!/bin/bash

while read script; do
    echo "Running ${script}"
    bash "${script}"
done < <(find /projects/common/bootstrap/scripts -type f | sort)

reboot
