#!/bin/bash

# Get the Python version and environment directory from command line arguments
PYTHON_VERSION=$1
ENV_DIR="$2/.env"

# Function to create the virtual environment
create_virtual_environment() {
    echo "Creating virtual environment..."
    python$PYTHON_VERSION -m venv "$ENV_DIR"
    if [ $? -ne 0 ]; then
        echo "Failed to create virtual environment. Please ensure Python $PYTHON_VERSION is installed correctly."
        exit 1
    fi
    echo "Virtual environment created: $ENV_DIR"
}

# Function to activate the virtual environment
activate_virtual_environment() {
    echo "Activating the virtual environment..."
    source "$ENV_DIR/bin/activate"
    if [ $? -ne 0 ]; then
        echo "Failed to activate virtual environment."
        exit 1
    fi
    echo "Virtual environment activated: $ENV_DIR"
}

# Check if the virtual environment exists, create if it doesn't
if [ ! -d "$ENV_DIR" ]; then
    create_virtual_environment
fi

# Activate the virtual environment
activate_virtual_environment

echo "The virtual environment is now active. You can start using Python $PYTHON_VERSION from this environment."