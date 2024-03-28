@echo off

REM Get the Python version from the command line argument
set PYTHON_VERSION=%1

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

REM Check if Python is already installed
call :is_python_installed
if %errorlevel% equ 0 (
    echo Python %PYTHON_VERSION% is already installed.
    goto :cleanup
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

:cleanup
REM Clean up the downloaded installer
if exist python_installer.exe (
    del python_installer.exe
)

echo Script execution completed.