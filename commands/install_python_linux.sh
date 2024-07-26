#!/bin/bash

# Get the environment directory from command line argument
ENV_DIR=$2

# Function to create and activate the virtual environment
create_and_activate_virtual_environment() {
    if [ ! -d "$ENV_DIR" ]; then
        echo "Creating virtual environment..."
        python3.11 -m venv "$ENV_DIR"
        if [ $? -ne 0 ]; then
            echo "Failed to create virtual environment. Please ensure Python 3.11 is installed."
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

# Create and activate the virtual environment
create_and_activate_virtual_environment

echo "Script execution completed."
echo "The virtual environment is now active. You can start using Python 3.11 from this environment."