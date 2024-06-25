@echo off
echo Received parameter: %1

python3 --version >nul 2>&1
if %errorlevel% equ 0 (
    if not exist %1 (
        python3 -m venv %1
    )
    call %1\Scripts\activate.bat
) else (
    python --version >nul 2>&1
    if %errorlevel% equ 0 (
        if not exist %1 (
            python -m venv %1
        )
        call %1\Scripts\activate.bat
    ) else (
        echo Python is not installed or not in the system PATH.
        exit /b 1
    )
)