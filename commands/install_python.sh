#!/bin/bash

# Get the Python version from the command line argument
PYTHON_VERSION=$1
ENV_DIR=$2

# Function to install Homebrew
install_homebrew() {
    echo "Installing Homebrew..."
    yes | /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
}

# Function to check if Homebrew is installed
is_homebrew_installed() {
    command -v brew > /dev/null
}

# Function to prompt for password using a dialog window
prompt_password() {
    osascript -e 'tell app "System Events" to display dialog "Enter your computers password to install Homebrew:" default answer "" with hidden answer' -e 'text returned of result'
}

# Function to install Python using Homebrew
install_python() {
    if ! brew list python@$PYTHON_VERSION > /dev/null
    then
        echo "Python $PYTHON_VERSION not found. Installing Python $PYTHON_VERSION using Homebrew..."
        brew install python@$PYTHON_VERSION
    else
        echo "Python $PYTHON_VERSION is already installed."
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

# Check if Homebrew is already installed
if is_homebrew_installed
then
    echo "Homebrew is already installed."
    install_python
else
    # Attempt 1: Install Homebrew with sudo
    echo "Attempting to install Homebrew with sudo..."
    PASSWORD=$(prompt_password)
    echo "$PASSWORD" | sudo -S -k /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" &
    sleep 5 # Wait for 5 seconds
    echo "$PASSWORD" | sudo -S kill $! > /dev/null 2>&1 # Terminate the sudo process if it's still running
    
    # Check if Homebrew is installed after Attempt 1
    if is_homebrew_installed
    then
        echo "Homebrew installation successful with sudo!"
        install_python
    else
        echo "Homebrew installation failed with sudo."
        
        # Attempt 2: Install Homebrew without sudo
        echo "Attempting to install Homebrew without sudo..."
        install_homebrew
        
        # Check if Homebrew is installed after Attempt 2
        if is_homebrew_installed
        then
            echo "Homebrew installation successful without sudo!"
            install_python
        else
            echo "Homebrew installation failed without sudo."
            echo "Bummer! Homebrew installation failed after all attempts."
            exit 1
        fi
    fi
fi

# Create a new virtual environment and activate it
create_and_activate_virtual_environment

echo "Script execution completed."