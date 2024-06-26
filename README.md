
# Python Installer Extension

This Visual Studio Code extension automates the installation of Python 3.11 on macOS, Windows, and Linux (Ubuntu) systems. It creates a virtual environment and activates it for you.

## Usage

1. Install the extension in Visual Studio Code.

2. Open the Command Palette (Cmd+Shift+P on macOS, Ctrl+Shift+P on Windows/Linux).

3. Type and select "Install Python" to run the installation command.

4. The extension will create a new terminal named "Python Installation" and execute the appropriate installation script based on your operating system.

5. Once the installation is complete, the terminal will automatically close after 10 seconds.

## Features

- Cross-platform support: Works on macOS, Windows, and Linux (Ubuntu).
- Automatic virtual environment creation and activation.
- Cleans up existing "Python Installation" terminals before creating a new one.
- Provides a callback mechanism for other extensions to execute commands after Python installation.

## Requirements

- Visual Studio Code version 1.84.0 or higher.
- Node.js version 16.17.1 or higher.

## Extension Settings

This extension contributes the following commands:

- `pythoninstaller.installPython`: Installs Python 3.11 and sets up a virtual environment.
- `pythoninstaller.addCallback`: Adds a callback function to be executed after Python installation.

## Notes

- On macOS and Linux, the extension uses shell scripts to install Python.
- On Windows, it uses a batch script to set up the Python environment.
- The extension creates a `.env` directory in the extension's path to store the virtual environment.

## Troubleshooting

If you encounter any issues during the installation process, please ensure that:
- You have a stable internet connection.
- You have the necessary permissions to install software on your system.
- Your system meets the minimum requirements for the extension.

If the issue persists, please check the extension's output in the Output panel (View -> Output) and select "Python Installer" from the dropdown menu for more detailed logs.
