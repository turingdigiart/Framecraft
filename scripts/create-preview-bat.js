#!/usr/bin/env node

/**
 * 自动创建标准化的预览脚本（最终修复版）
 * 用法: node create-preview-bat.js [项目目录名]
 */

const fs = require('fs');
const path = require('path');

// 获取项目目录名
const projectDir = process.argv[2] || process.cwd();
const projectName = path.basename(projectDir);

// 预览脚本模板（最终修复版 - 使用 cd 命令避免路径问题）
const previewBatTemplate = `@echo off
echo ==========================================
echo     ${projectName}
echo     Remotion Animation Preview Server
echo ==========================================
echo.

REM Change to script directory
cd /d "%~dp0"

REM Go to parent directory (Demo root)
cd ..

REM Set parent directory as variable
set "DEMO_ROOT=%CD%"

REM Go back to project directory
cd "%~dp0"

echo [Current Directory]: %CD%
echo [Demo Root]: %DEMO_ROOT%
echo [Server Address]: http://localhost:3000
echo.
echo [Features]:
echo    - Open http://localhost:3000 in browser
echo    - Real-time animation preview
echo    - Press Ctrl+C to stop server
echo    - Close this window to stop server
echo.
echo [Starting Remotion Studio]...
echo.

REM Try to execute remotion
"%DEMO_ROOT%\\node_modules\\.bin\\remotion.CMD" studio src/index.ts

if errorlevel 1 (
    echo.
    echo [Error]: Failed to start remotion studio
    echo.
    echo [Troubleshooting]:
    echo 1. Check if dependencies are installed:
    echo    cd "%DEMO_ROOT%"
    echo    pnpm install
    echo.
    echo 2. Check if remotion exists:
    echo    dir "%DEMO_ROOT%\\node_modules\\.bin"
    echo.
)

echo.
echo Server stopped
pause`;

// 创建预览脚本
const previewBatPath = path.join(projectDir, '预览.bat');

console.log(`🚀 Creating preview script for "${projectName}"...`);

try {
    fs.writeFileSync(previewBatPath, previewBatTemplate, 'utf8');
    console.log(`✅ Preview script created: ${previewBatPath}`);
    console.log('');
    console.log('📝 How to use:');
    console.log('   1. Double-click 预览.bat to start preview server');
    console.log('   2. Open http://localhost:3000 in browser');
    console.log('   3. Press Ctrl+C or close window to stop server');
    console.log('');
    console.log('🔧 Fixed features:');
    console.log('   - Uses cd command to avoid path issues');
    console.log('   - Auto-detects parent directory');
    console.log('   - Shows clear error messages if remotion not found');
    console.log('   - Works with Chinese characters in path');
} catch (error) {
    console.error(`❌ Failed to create preview script: ${error.message}`);
    process.exit(1);
}