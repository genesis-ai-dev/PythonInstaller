#!/bin/bash

# Get the Python version from the command line argument
PYTHON_VERSION=$1

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

# Check if Homebrew is already installed
if is_homebrew_installed
then
    echo "Homebrew is already installed."
    install_python
    exit 0
fi

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
    exit 0
else
    echo "Homebrew installation failed with sudo."
fi

# Attempt 2: Install Homebrew without sudo
echo "Attempting to install Homebrew without sudo..."
install_homebrew

# Check if Homebrew is installed after Attempt 2
if is_homebrew_installed
then
    echo "Homebrew installation successful without sudo!"
    install_python
    exit 0
else
    echo "Homebrew installation failed without sudo."
    echo "Bummer! Homebrew installation failed after all attempts."
    exit 1
fi

echo "Script execution completed."