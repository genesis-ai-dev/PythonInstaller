@echo off
setlocal enabledelayedexpansion

echo Received parameter: %1

set "PYTHON_CMD="
for %%P in (python3.exe python.exe) do (
    where %%P >nul 2>&1 && set "PYTHON_CMD=%%P" && goto :found_python
)

:found_python
if not defined PYTHON_CMD (
    echo Python is not installed or not in the system PATH.
    exit /b 1
)

if not exist "%1" (
    "%PYTHON_CMD%" -m venv "%1"
)

if exist "%1\Scripts\activate.bat" (
    call "%1\Scripts\activate.bat"
) else if exist "%1\bin\activate" (
    call "%1\bin\activate"
) else (
    echo Activation script not found in expected locations.
    exit /b 1
)

echo Python environment activated successfully.
"%PYTHON_CMD%" --version