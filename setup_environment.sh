#!/bin/bash

# Ask for environment name
read -p "Enter the name for your new Conda environment: " env_name

# Ask for Python version
read -p "Enter the Python version (e.g., 3.8, 3.9, etc.): " python_version

# Ask user to select specialization
echo "Select your specialization:"
echo "1. Data Engineering"
echo "2. Machine Learning Engineering"
read -p "Enter your choice (1 or 2): " specialization

# Define basic libraries based on specialization
if [ "$specialization" -eq 1 ]; then
    basic_libraries=(pandas jupyterlab psycopg2-binary sqlalchemy fastapi seaborn requests)
    echo "The following basic libraries for Data Engineering will be installed: ${basic_libraries[@]}"
elif [ "$specialization" -eq 2 ]; then
    basic_libraries=(scikit-learn pandas seaborn jupyterlab)
    echo "The following basic libraries for Machine Learning Engineering will be installed: ${basic_libraries[@]}"
else
    echo "Invalid choice. Exiting."
    exit 1
fi

# Create a new conda environment with the specified Python version
echo "Creating a new Conda environment '$env_name' with Python $python_version..."
conda create -n "$env_name" python="$python_version" -y

# Activate the newly created environment
source "$(conda info --base)/etc/profile.d/conda.sh"
conda activate "$env_name"

# Install basic libraries from conda-forge
for library in "${basic_libraries[@]}"; do
    echo "Trying to install '$library' via conda-forge..."
    conda install -c conda-forge "$library" -y 2>/dev/null

    # If the package wasn't found on conda-forge, fall back to pip
    if [ $? -ne 0 ]; then
        echo "'$library' not found on conda-forge. Installing via pip..."
        pip install "$library"
    fi
done

# Ask for a list of additional libraries to install
read -p "Enter any additional libraries to install (space-separated): " -a additional_libraries

# Install additional libraries
for library in "${additional_libraries[@]}"; do
    echo "Trying to install '$library' via conda-forge..."
    conda install -c conda-forge "$library" -y 2>/dev/null

    if [ $? -ne 0 ]; then
        echo "'$library' not found on conda-forge. Installing via pip..."
        pip install "$library"
    fi
done

# Confirm installation status
echo "Installation completed. To use your environment, activate it with: conda activate $env_name"
