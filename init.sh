#!/bin/bash

while read script; do
    echo "Running ${script}"
    bash "${script}"
done < <(find scripts -type f)
