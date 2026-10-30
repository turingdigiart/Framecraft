@echo off
chcp 65001 >nul
echo ==========================================
echo     EasyC++ 动画项目生成器
echo ==========================================
echo.

if "%~1"=="" (
    echo 用法: create-new-animation.bat [项目名称]
    echo.
    echo 示例: create-new-animation.bat while-loop-animation
    echo.
    pause
    exit /b 1
)

set "PROJECT_NAME=%~1"
set "DEMO_DIR=E:\BaiduSync\BaiduSyncdisk\TuringTechLab\课程\C++\EasyC++\Template\Demo"
set "NEW_PROJECT_DIR=%DEMO_DIR%\%PROJECT_NAME%"

echo 📁 项目名称: %PROJECT_NAME%
echo 📂 创建目录: %NEW_PROJECT_DIR%
echo.

REM 检查项目是否已存在
if exist "%NEW_PROJECT_DIR%" (
    echo ❌ 错误: 项目目录已存在！
    echo    %NEW_PROJECT_DIR%
    echo.
    pause
    exit /b 1
)

REM 创建项目目录结构
echo 📝 创建项目目录结构...
mkdir "%NEW_PROJECT_DIR%"
mkdir "%NEW_PROJECT_DIR%\src"
mkdir "%NEW_PROJECT_DIR%\src\components"

REM 创建 package.json
echo 📦 创建 package.json...
(
echo {
echo   "name": "%PROJECT_NAME%",
echo   "version": "1.0.0",
echo   "private": true,
echo   "description": "%PROJECT_NAME% animation demo for EasyC++ course",
echo   "scripts": {
echo     "start": "remotion studio",
echo     "build": "remotion render"
echo   }
echo }
) > "%NEW_PROJECT_DIR%\package.json"

REM 创建 TypeScript 配置
echo 🔧 创建 tsconfig.json...
(
echo {
echo   "compilerOptions": {
echo     "target": "ES2022",
echo     "module": "ES2022",
echo     "moduleResolution": "node",
echo     "jsx": "react",
echo     "strict": true,
echo     "esModuleInterop": true,
echo     "skipLibCheck": true,
echo     "forceConsistentCasingInFileNames": true,
echo     "resolveJsonModule": true,
echo     "isolatedModules": true,
echo     "noEmit": true
echo   },
echo   "include": ["src/**/*"],
echo   "exclude": ["node_modules"]
echo }
) > "%NEW_PROJECT_DIR%\tsconfig.json"

REM 创建 Remotion 配置
echo 🎬 创建 remotion.config.ts...
(
echo import {Config} from '@remotion/cli/config';
echo
echo export default Config.getBundledConfig();
) > "%NEW_PROJECT_DIR%\remotion.config.ts"

REM 创建入口文件
echo 📄 创建 src/index.ts...
(
echo import {registerRoot} from 'remotion';
echo import {Root} from './Root';
echo
echo registerRoot(Root);
) > "%NEW_PROJECT_DIR%\src\index.ts"

REM 创建 Root 组件
echo 📄 创建 src/Root.tsx...
(
echo import React from 'react';
echo import {Composition} from 'remotion';
echo import {Demo} from './Demo';
echo
echo export const Root: React.FC = () =^> {
echo   return (
echo     ^<^>
echo       ^<Composition
echo         id="Demo"
echo         component={Demo}
echo         durationInFrames={900}
echo         fps={30}
echo         width={1920}
echo         height={1080}
echo       /^>
echo     ^<^>
echo   );
echo };
) > "%NEW_PROJECT_DIR%\src\Root.tsx"

REM 创建演示组件
echo 📄 创建 src/Demo.tsx...
(
echo import React from 'react';
echo import {AbsoluteFill} from 'remotion';
echo
echo export const Demo: React.FC = () =^> {
echo   return (
echo     ^<AbsoluteFill
echo       style={{
echo         backgroundColor: '#0f0f23',
echo         color: 'white',
echo         justifyContent: 'center',
echo         alignItems: 'center',
echo         fontSize: 80,
echo         fontWeight: 'bold',
echo       }}
echo     ^>
echo       %PROJECT_NAME%
echo     ^</AbsoluteFill^>
echo   );
echo };
) > "%NEW_PROJECT_DIR%\src\Demo.tsx"

REM 创建样式文件
echo 🎨 创建 src/styles.ts...
(
echo // VS Code Dark+ 主题颜色
echo export const COL = {
echo   bgTop: '#000000',
echo   bgMid: '#1a1a1a',
echo   bgBot: '#2d2d30',
echo   textPri: '#d4d4d4',
echo   keyword: '#569cd6',
echo   type: '#4ec9b0',
echo   variable: '#9cdcfe',
echo   literal: '#b5cea8',
echo };
echo
echo export const FONT_UI = 'Microsoft YaHei, Arial, sans-serif';
echo export const FONT_CODE = 'Consolas, monospace';
echo
echo export const backgroundStyle = {
echo   background: \`linear-gradient(to bottom, \${COL.bgTop} 0%, \${COL.bgMid} 40%, \${COL.bgBot} 100%)\`,
echo   color: COL.textPri,
echo   fontFamily: FONT_UI,
echo };
) > "%NEW_PROJECT_DIR%\src\styles.ts"

REM 创建预览脚本
echo 🚀 创建预览脚本...
node "%DEMO_DIR%\create-preview-bat.js" "%NEW_PROJECT_DIR%"

REM 复制设计规范（如果存在）
if exist "%DEMO_DIR%\foreach-int-vs-ref-animation\DESIGN_STYLE.md" (
    echo 📋 复制设计规范...
    copy "%DEMO_DIR%\foreach-int-vs-ref-animation\DESIGN_STYLE.md" "%NEW_PROJECT_DIR%\DESIGN_STYLE.md" >nul
)

REM 创建 README
echo 📖 创建 README.md...
(
echo # %PROJECT_NAME%
echo
echo ## 🎯 项目说明
echo
echo %PROJECT_NAME% 动画演示项目，用于 EasyC++ 课程教学。
echo
echo ## 🚀 快速开始
echo
echo ### 预览动画
echo 1. 双击 \`预览.bat\` 启动预览服务器
echo 2. 浏览器访问 \`http://localhost:3000\`
echo 3. 开始预览动画效果
echo
echo ## 📁 项目结构
echo
echo \`\`\`
echo %PROJECT_NAME%/
echo ├── 📄 预览.bat           ← 启动预览
echo ├── 📁 src/
echo │   ├── index.ts          ← 入口文件
echo │   ├── Root.tsx          ← 根组件
echo │   ├── Demo.tsx          ← 主演示组件
echo │   ├── components/      ← 可复用组件
echo │   └── styles.ts         ← 样式常量
echo ├── 📄 package.json
echo ├── 📄 tsconfig.json
echo ├── 📄 remotion.config.ts
echo └── 📄 DESIGN_STYLE.md    ← 设计规范
echo \`\`\`
echo
echo ## 🎨 开发指南
echo
echo - 修改 \`src/Demo.tsx\` 编辑动画内容
echo - 添加组件到 \`src/components/\`
echo - 遵循 \`DESIGN_STYLE.md\` 的设计规范
echo
echo ## 📝 注意事项
echo
echo - 所有项目共享依赖，无需单独安装 node_modules
echo - 使用 VS Code Dark+ 主题配色
echo - 遵循 EasyC++ 统一设计规范
echo
echo ---
echo
echo 生成时间: %date% %time%
) > "%NEW_PROJECT_DIR%\README.md"

echo.
echo ==========================================
echo     ✅ 项目创建成功！
echo ==========================================
echo.
echo 📁 项目位置: %NEW_PROJECT_DIR%
echo.
echo 🚀 下一步:
echo    1. cd "%NEW_PROJECT_DIR%"
echo    2. 双击 "预览.bat" 启动预览
echo    3. 编辑 src/Demo.tsx 创建动画
echo.
echo 📚 参考文档:
echo    - STANDARD_WORKFLOW.md - 工作流程指南
echo    - DESIGN_STYLE.md - 设计规范
echo    - ANIMATION_STANDARDS.md - 动画标准
echo.
pause