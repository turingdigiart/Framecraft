@echo off
chcp 65001 >nul
setlocal
rem ============================================================
rem  Framecraft · 新建演示动画包
rem  用法: create-new-animation.bat "<工程目录>" <包名>
rem  例:   create-new-animation.bat "E:\Private\AIDev\TECH-EASYCPP-RESTARTPROJECTA-001" my-topic
rem  说明: 不写死任何路径；TOOLS_ROOT 由环境变量或 ~/.turing/bindings.json 解析
rem ============================================================
set "PROJECT=%~1"
set "NAME=%~2"
if "%PROJECT%"=="" goto :usage
if "%NAME%"=="" goto :usage
if not exist "%PROJECT%" (
  echo [ERROR] 工程目录不存在: %PROJECT%
  exit /b 1
)

set "TROOT=%TOOLS_ROOT%"
if "%TROOT%"=="" (
  for /f "usebackq delims=" %%A in (`powershell -NoProfile -Command "try{(Get-Content (Join-Path $env:USERPROFILE '.turing\bindings.json') -Raw -Encoding UTF8 | ConvertFrom-Json).TOOLS_ROOT}catch{}"`) do set "TROOT=%%A"
)
if "%TROOT%"=="" (
  echo [ERROR] TOOLS_ROOT 未绑定，见 MACHINE_BINDINGS.md
  exit /b 1
)
set "FC=%TROOT%\framecraft"
if not exist "%FC%\templates\package\package.json" (
  echo [ERROR] Framecraft 样板缺失: %FC%\templates\package
  exit /b 1
)

set "DEST=%PROJECT%\demos\%NAME%-animation"
if exist "%DEST%" (
  echo [ERROR] 目标已存在，不覆盖: %DEST%
  exit /b 1
)
mkdir "%DEST%" 2>nul
if not exist "%DEST%" (
  echo [ERROR] 无法创建目录: %DEST%
  exit /b 1
)

echo [1/4] 复制样板 ...
xcopy "%FC%\templates\package\*" "%DEST%\" /E /I /Y >nul
if errorlevel 1 (
  echo [ERROR] 复制样板失败
  exit /b 1
)

echo [2/4] 生成 package.json ...
> "%DEST%\package.json" echo {
>>"%DEST%\package.json" echo   "name": "%NAME%-animation",
>>"%DEST%\package.json" echo   "version": "1.0.0",
>>"%DEST%\package.json" echo   "private": true,
>>"%DEST%\package.json" echo   "scripts": {
>>"%DEST%\package.json" echo     "start": "remotion studio src/index.ts",
>>"%DEST%\package.json" echo     "build": "remotion render src/index.ts out/%NAME%.mp4",
>>"%DEST%\package.json" echo     "dev": "remotion studio src/index.ts"
>>"%DEST%\package.json" echo   }
>>"%DEST%\package.json" echo }

echo [3/4] 生成场景骨架 ...
> "%DEST%\src\Root.tsx" echo import { Composition } from "remotion";
>>"%DEST%\src\Root.tsx" echo import { Demo } from "./Demo";
>>"%DEST%\src\Root.tsx" echo.
>>"%DEST%\src\Root.tsx" echo const TOTAL_DURATION = 300;
>>"%DEST%\src\Root.tsx" echo.
>>"%DEST%\src\Root.tsx" echo export const RemotionRoot: React.FC = () => {
>>"%DEST%\src\Root.tsx" echo   return (
>>"%DEST%\src\Root.tsx" echo     ^<^>
>>"%DEST%\src\Root.tsx" echo       ^<Composition
>>"%DEST%\src\Root.tsx" echo         id="%NAME%"
>>"%DEST%\src\Root.tsx" echo         component={Demo}
>>"%DEST%\src\Root.tsx" echo         durationInFrames={TOTAL_DURATION}
>>"%DEST%\src\Root.tsx" echo         fps={30}
>>"%DEST%\src\Root.tsx" echo         width={1920}
>>"%DEST%\src\Root.tsx" echo         height={1080}
>>"%DEST%\src\Root.tsx" echo       /^>
>>"%DEST%\src\Root.tsx" echo     ^<^/^>
>>"%DEST%\src\Root.tsx" echo   );
>>"%DEST%\src\Root.tsx" echo };

> "%DEST%\src\Demo.tsx" echo import { AbsoluteFill } from "remotion";
>>"%DEST%\src\Demo.tsx" echo.
>>"%DEST%\src\Demo.tsx" echo export const Demo: React.FC = () => {
>>"%DEST%\src\Demo.tsx" echo   return (
>>"%DEST%\src\Demo.tsx" echo     ^<AbsoluteFill style={{ backgroundColor: "#0b0f19", color: "#e6edf3" }}^>
>>"%DEST%\src\Demo.tsx" echo       ^<h1^>%NAME%^</h1^>
>>"%DEST%\src\Demo.tsx" echo     ^<^/AbsoluteFill^>
>>"%DEST%\src\Demo.tsx" echo   );
>>"%DEST%\src\Demo.tsx" echo };

echo [4/4] 链接 Framecraft 依赖 ...
if exist "%PROJECT%\demos\link-framecraft.ps1" (
  pushd "%PROJECT%\demos"
  powershell -NoProfile -ExecutionPolicy Bypass -File ".\link-framecraft.ps1"
  popd
) else (
  echo [WARN] 缺 demos\link-framecraft.ps1，需手动链接
)

echo.
echo 完成: %DEST%
echo 下一步:
echo   cd "%PROJECT%\demos"
echo   pnpm install
echo   pnpm --dir "%NAME%-animation" start
exit /b 0

:usage
echo 用法: create-new-animation.bat "<工程目录>" ^<包名^>
echo   例: create-new-animation.bat "E:\Private\AIDev\TECH-EASYCPP-RESTARTPROJECTA-001" my-topic
exit /b 1
