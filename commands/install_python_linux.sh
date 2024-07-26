#!/bin/bash

# Get the Python version and environment directory from command line arguments
PYTHON_VERSION=$1
ENV_DIR="$2/.env"

# Function to check if Python is installed
check_python_installed() {
    if ! command -v python$PYTHON_VERSION &> /dev/null; then
        echo "Python $PYTHON_VERSION is not installed. Please install it first."
        exit 1
    fi
}

# Function to create and activate the virtual environment
create_and_activate_virtual_environment() {
    if [ ! -d "$ENV_DIR" ]; then
        echo "Creating virtual environment..."
        python$PYTHON_VERSION -m venv "$ENV_DIR"
        if [ $? -ne 0 ]; then
            echo "Failed to create virtual environment. Please ensure Python $PYTHON_VERSION is installed correctly."
            exit 1
        fi
        echo "Virtual environment created: $ENV_DIR"
    else
        echo "Virtual environment already exists: $ENV_DIR"
    fi

    echo "Activating the virtual environment..."
    source "$ENV_DIR/bin/activate"
    if [ $? -ne 0 ]; then
        echo "Failed to activate virtual environment."
        exit 1
    fi
    echo "Virtual environment activated: $ENV_DIR"
}

# Check if Python is installed
check_python_installed

# Create and activate the virtual environment
create_and_activate_virtual_environment

echo "Script execution completed."
echo "The virtual environment is now active. You can start using Python $PYTHON_VERSION from this environment."