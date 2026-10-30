@echo off
chcp 65001 >nul
setlocal
rem ============================================================
rem  Framecraft · 重置演示工作区的依赖
rem  用法: clean-and-reset.bat "<demos 目录>" [-y]
rem  作用: 删除 node_modules 后重装（不删 pnpm-lock.yaml，锁文件必须保留）
rem  说明: 不写死路径；不带 -y 时会二次确认
rem ============================================================
set "DEMOS=%~1"
set "YES=%~2"
if "%DEMOS%"=="" goto :usage
if not exist "%DEMOS%" (
  echo [ERROR] 目录不存在: %DEMOS%
  exit /b 1
)

if /i not "%YES%"=="-y" (
  echo 即将删除以下目录下的全部 node_modules 并重装:
  echo   %DEMOS%
  set /p CONFIRM=确认继续? 输入 Y 回车:
  if /i not "%CONFIRM%"=="Y" (
    echo 已取消。
    exit /b 1
  )
)

echo [1/3] 删除 node_modules ...
if exist "%DEMOS%\node_modules" rmdir /s /q "%DEMOS%\node_modules"
for /d %%d in ("%DEMOS%\*-animation") do (
  if exist "%%d\node_modules" rmdir /s /q "%%d\node_modules"
)

echo [2/3] 重新链接 Framecraft ...
if exist "%DEMOS%\link-framecraft.ps1" (
  pushd "%DEMOS%"
  powershell -NoProfile -ExecutionPolicy Bypass -File ".\link-framecraft.ps1"
  popd
)

echo [3/3] 重新安装 ...
pushd "%DEMOS%"
set CI=true
call pnpm install
set "CODE=%errorlevel%"
popd
if not "%CODE%"=="0" (
  echo [ERROR] pnpm install 失败，退出码 %CODE%
  exit /b %CODE%
)

echo.
echo 完成。启动某个演示:
echo   cd "%DEMOS%"
echo   pnpm --dir ^<包名^> start
exit /b 0

:usage
echo 用法: clean-and-reset.bat "^<demos 目录^>" [-y]
echo   例: clean-and-reset.bat "E:\Private\AIDev\TECH-EASYCPP-RESTARTPROJECTA-001\demos" -y
exit /b 1
