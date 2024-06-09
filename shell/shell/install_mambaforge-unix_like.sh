#!/bin/bash

curl -L -O "https://github.com/conda-forge/miniforge/releases/latest/download/Mambaforge-$(uname)-$(uname -m).sh" 
bash Mambaforge-$(uname)-$(uname -m).sh -b -p "$HOME/.opt/conda" 
rm Mambaforge-$(uname)-$(uname -m).sh
$HOME/.opt/conda/bin/conda run -n base conda init zsh
$HOME/.opt/conda/bin/conda run -n base conda init bash
# $HOME/.opt/conda/bin/conda run -n base conda config --set changeps1 False
