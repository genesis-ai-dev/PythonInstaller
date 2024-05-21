#!/bin/bash

# Get the Python version from the command line argument
PYTHON_VERSION=$1
ENV_DIR=$2

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

# Check if Python is installed
if ! command -v python$PYTHON_VERSION &> /dev/null
then
    echo "Python $PYTHON_VERSION is not installed. Please install Python $PYTHON_VERSION and try again."
    exit 1
fi

# Create a new virtual environment and activate it
create_and_activate_virtual_environment

echo "Script execution completed."