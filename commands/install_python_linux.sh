#!/bin/bash

# Get the Python version from the command line argument
PYTHON_VERSION=$1
ENV_DIR=$2

# Function to install Python
install_python() {
    echo "Python $PYTHON_VERSION is not installed. Attempting to install..."
    if command -v apt-get &> /dev/null; then
        sudo apt-get update
        sudo apt-get install -y python$PYTHON_VERSION python$PYTHON_VERSION-venv
    elif command -v yum &> /dev/null; then
        sudo yum -y update
        sudo yum -y install python$PYTHON_VERSION python$PYTHON_VERSION-devel
    else
        echo "Unable to install Python. Please install Python $PYTHON_VERSION manually."
        exit 1
    fi
}

# Function to create a new virtual environment and activate it
create_and_activate_virtual_environment() {
    if [ ! -d "$ENV_DIR" ]; then
        echo "Creating a new virtual environment in $ENV_DIR..."
        python$PYTHON_VERSION -m venv "$ENV_DIR"
        echo "Virtual environment created: $ENV_DIR"
    else
        echo "Virtual environment already exists: $ENV_DIR"
    fi
    
    # Activate the virtual environment
    echo "Activating the virtual environment..."
    source "$ENV_DIR/bin/activate"
    echo "Virtual environment activated."
}

# Check if Python is installed, if not, install it
if ! command -v python$PYTHON_VERSION &> /dev/null
then
    install_python
fi

# Verify Python installation
if ! command -v python$PYTHON_VERSION &> /dev/null
then
    echo "Failed to install Python $PYTHON_VERSION. Please install it manually and try again."
    exit 1
fi

# Create a new virtual environment and activate it
create_and_activate_virtual_environment

echo "Script execution completed."