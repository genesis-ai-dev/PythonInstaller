@echo off

REM Get the Python version and virtual environment directory from the command line arguments
set PYTHON_VERSION=%1
set ENV_DIR=%2

REM Function to download the Python installer
:download_python
echo Downloading Python %PYTHON_VERSION% installer...
powershell -Command "Invoke-WebRequest -Uri 'https://www.python.org/ftp/python/%PYTHON_VERSION%/python-%PYTHON_VERSION%-amd64.exe' -OutFile 'python_installer.exe'"
goto :eof

REM Function to install Python
:install_python
echo Installing Python %PYTHON_VERSION%...
python_installer.exe /quiet InstallAllUsers=1 PrependPath=1 Include_test=0
goto :eof

REM Function to check if Python is installed
:is_python_installed
python --version | findstr /C:"Python %PYTHON_VERSION%" > nul
if %errorlevel% equ 0 (
    echo Python %PYTHON_VERSION% is already installed.
    exit /b 0
) else (
    exit /b 1
)
goto :eof

REM Function to create a new virtual environment and activate it
:create_and_activate_virtual_environment
if not exist "%ENV_DIR%" (
    echo Creating a new virtual environment in %ENV_DIR%...
    python -m venv "%ENV_DIR%"
    echo Virtual environment created: %ENV_DIR%
) else (
    echo Virtual environment already exists: %ENV_DIR%
)

echo Activating the virtual environment...
call "%ENV_DIR%\Scripts\activate.bat"
echo Virtual environment activated.
goto :eof

REM Check if Python is already installed
call :is_python_installed
if %errorlevel% equ 0 (
    echo Python %PYTHON_VERSION% is already installed.
    goto :create_env
)

REM Download the Python installer
call :download_python

REM Install Python
call :install_python

REM Check if Python is installed after the installation attempt
call :is_python_installed
if %errorlevel% equ 0 (
    echo Python %PYTHON_VERSION% installation successful!
) else (
    echo Python %PYTHON_VERSION% installation failed.
    goto :cleanup
)

:create_env
REM Create a new virtual environment and activate it
call :create_and_activate_virtual_environment

:cleanup
REM Clean up the downloaded installer
if exist python_installer.exe (
    del python_installer.exe
)

echo Script execution completed.