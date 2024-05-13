#!/bin/bash

# Ask for environment name
read -p "Enter the name for your new Conda environment: " env_name

# Ask for Python version
read -p "Enter the Python version (e.g., 3.8, 3.9, etc.): " python_version

# Create a new conda environment with the specified Python version
echo "Creating a new Conda environment '$env_name' with Python $python_version..."
conda create -n "$env_name" python="$python_version" -y

# Activate the newly created environment
source "$(conda info --base)/etc/profile.d/conda.sh"
conda activate "$env_name"

# Ask for a list of libraries to install
read -p "Enter the libraries to install (space-separated): " -a libraries

# Iterate over each library and try installing through conda-forge first
for library in "${libraries[@]}"; do
    echo "Trying to install '$library' via conda-forge..."
    conda install -c conda-forge "$library" -y 2>/dev/null

    # If the package wasn't found on conda-forge, fall back to pip
    if [ $? -ne 0 ]; then
        echo "'$library' not found on conda-forge. Installing via pip..."
        pip install "$library"
    fi
done

# Confirm installation status
echo "Installation completed. To use your environment, activate it with: conda activate $env_name"
