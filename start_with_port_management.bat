@echo off
chcp 65001 >nul

:: 确保在脚本所在目录执行
cd /d "%~dp0"

echo =====================================
echo 错题库系统 - 端口管理与启动脚本
echo =====================================
echo.

:: 定义端口
echo 1. 检查端口占用情况...
echo -------------------------------------
set FRONTEND_PORT=5173
set BACKEND_PORT=3001

:: 检查并释放后端端口 3001
netstat -ano | findstr :%BACKEND_PORT% >nul
if %errorlevel% equ 0 (
    echo 端口 %BACKEND_PORT% 被占用，正在释放...
    for /f "tokens=5" %%a in ('netstat -ano ^| findstr :%BACKEND_PORT%') do (
        taskkill /pid %%a /f >nul 2>&1
        echo 已终止进程 %%a
    )
) else (
    echo 端口 %BACKEND_PORT% 可用
)

:: 检查并释放前端端口 5173
netstat -ano | findstr :%FRONTEND_PORT% >nul
if %errorlevel% equ 0 (
    echo 端口 %FRONTEND_PORT% 被占用，正在释放...
    for /f "tokens=5" %%a in ('netstat -ano ^| findstr :%FRONTEND_PORT%') do (
        taskkill /pid %%a /f >nul 2>&1
        echo 已终止进程 %%a
    )
) else (
    echo 端口 %FRONTEND_PORT% 可用
)

echo.
echo 2. 启动错题库系统...
echo -------------------------------------
echo 正在启动后端服务...
echo 正在启动前端服务...
echo.
echo 服务启动中，请稍候...
echo.
echo 访问地址：
echo - 前端：http://localhost:%FRONTEND_PORT%
echo - 后端 API：http://localhost:%BACKEND_PORT%/api
echo - 健康检查：http://localhost:%BACKEND_PORT%/health
echo.
echo 按 Ctrl+C 停止所有服务
echo =====================================
echo.

:: 检查npm是否可用
where npm >nul 2>&1
if %errorlevel% neq 0 (
    echo 错误：未找到npm命令，请确保已安装Node.js并配置好环境变量
echo.
    pause
    exit /b 1
)

:: 检查package.json是否存在
if not exist "package.json" (
    echo 错误：未找到package.json文件，请确保在项目根目录执行此脚本
echo.
    pause
    exit /b 1
)

:: 启动服务
echo 正在执行 npm run dev...
echo.
npm run dev

:: 检查服务启动是否成功
if %errorlevel% neq 0 (
    echo.
    echo 错误：服务启动失败，请检查终端输出的错误信息
echo.
    pause
    exit /b 1
)

