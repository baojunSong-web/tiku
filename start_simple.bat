@echo off

:: Make sure we're in the correct directory
cd /d "%~dp0"

:: Clear screen
echo.
echo =====================================
echo TIKU SYSTEM - START SCRIPT
echo =====================================
echo.

:: Check if Node.js is installed
echo 1. Checking Node.js environment...
node --version >nul 2>&1
if errorlevel 1 (
    echo ERROR: Node.js is not installed!
    echo Please install Node.js first from https://nodejs.org/
    pause
    exit /b 1
)

echo Node.js is installed.
echo.

:: Kill processes using our ports
echo 2. Freeing up ports...

echo Freeing port 3001...
taskkill /f /im node.exe >nul 2>&1
echo Freeing port 5173...
taskkill /f /im vite.exe >nul 2>&1

:: Also try with netstat
for /f "tokens=5" %%a in ('netstat -ano ^| findstr :3001') do taskkill /f /pid %%a >nul 2>&1
for /f "tokens=5" %%a in ('netstat -ano ^| findstr :5173') do taskkill /f /pid %%a >nul 2>&1

echo Ports freed successfully.
echo.

:: Install dependencies if needed
echo 3. Checking dependencies...
if not exist "node_modules" (
    echo Installing dependencies...
    npm install
    if errorlevel 1 (
        echo ERROR: Failed to install dependencies!
        pause
        exit /b 1
    )
    echo Dependencies installed successfully.
) else (
    echo Dependencies already installed.
)
echo.

:: Start the system
echo 4. Starting the system...
echo =====================================
echo Access URLs:
echo - Frontend: http://localhost:5173
echo - Backend API: http://localhost:3001/api
echo - Health Check: http://localhost:3001/health
echo =====================================
echo.
echo Press Ctrl+C to stop the system.
echo.

:: Start services
npm run dev

:: Check if start was successful
if errorlevel 1 (
    echo.
    echo ERROR: Failed to start the system!
    pause
    exit /b 1
)
