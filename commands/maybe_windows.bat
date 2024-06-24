@echo off
python3 --version >nul 2>&1
if %errorlevel% equ 0 (
    if not exist venv (
        python3 -m venv venv
    )
    venv\Scripts\activate.bat
) else (
    python3
)