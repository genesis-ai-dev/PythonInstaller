@echo off
python3 --version >nul 2>&1
if %errorlevel% equ 0 (
    if not exist .env (
        python3 -m venv .env
    )
    .env\Scripts\activate.bat
) else (
    python --version >nul 2>&1
    if %errorlevel% equ 0 (
        if not exist .env (
            python -m venv .env
        )
        .env\Scripts\activate.bat
    ) else (
        echo Python is not installed or not in the system PATH.
        exit /b 1
    )
)