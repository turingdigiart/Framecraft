@echo off
echo ==========================================
echo 彻底清理和重新设置 pnpm workspace
echo ==========================================

cd /d "E:\BaiduSync\BaiduSyncdisk\TuringTechLab\课程\C++\EasyC++\Template\Demo"

echo.
echo 步骤 1: 删除根目录的 node_modules 和 lock 文件
if exist node_modules (
    echo 正在删除根目录 node_modules...
    rmdir /s /q node_modules
)
if exist pnpm-lock.yaml (
    echo 正在删除 pnpm-lock.yaml...
    del /q pnpm-lock.yaml
)

echo.
echo 步骤 2: 删除所有子项目的 node_modules 和 lock 文件
for /D %%d in (*) do (
    if exist "%%d\node_modules" (
        echo 正在删除 %%d\node_modules...
        rmdir /s /q "%%d\node_modules" 2>nul
    )
    if exist "%%d\package-lock.json" (
        echo 正在删除 %%d\package-lock.json...
        del /q "%%d\package-lock.json"
    )
)

echo.
echo 步骤 3: 清理 pnpm 缓存
pnpm store prune

echo.
echo 步骤 4: 重新安装 workspace 依赖
pnpm install

echo.
echo 步骤 5: 验证安装结果
pnpm list --depth 0

echo.
echo ==========================================
echo 清理和重设完成！
echo ==========================================
echo.
echo 现在你可以使用以下命令启动项目：
echo   pnpm start:foreach-int
echo   pnpm start:for-loop
echo   pnpm start:enum
echo.
pause