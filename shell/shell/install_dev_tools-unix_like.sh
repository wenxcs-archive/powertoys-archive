#!/bin/bash

if command -v conda &> /dev/null ; then
    conda install -y -c conda-forge vim nodejs tmux zsh clang-tools fzf
fi
