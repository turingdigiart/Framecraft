#!/usr/bin/env node

/**
 * 批量更新所有子项目的 package.json
 * 移除重复的依赖，准备迁移到 pnpm workspace
 */

const fs = require('fs');
const path = require('path');
const { execSync } = require('child_process');

// 所有子项目目录
const projects = [
  'enum-structure-animation',
  'for-loop-animation',
  'for-loop-format-animation',
  'foreach-structure-animation',
  'switch-case-animation',
  'switch-fallthrough-animation'
];

// 简化的 package.json 模板
const minimalPackageJson = (name, description) => ({
  name,
  version: "1.0.0",
  private: true,
  description,
  scripts: {
    start: "remotion studio",
    build: "remotion render",
    dev: "remotion studio"
  },
  engines: {
    node: ">=16.0.0",
    pnpm: ">=8.0.0"
  }
});

console.log('🚀 开始批量更新所有项目的 package.json...\n');

projects.forEach(projectName => {
  const projectPath = path.join(__dirname, projectName);
  const packageJsonPath = path.join(projectPath, 'package.json');

  try {
    // 读取现有的 package.json
    const existingPackage = JSON.parse(fs.readFileSync(packageJsonPath, 'utf8'));

    // 创建新的简化版本
    const newPackage = minimalPackageJson(
      existingPackage.name || projectName,
      existingPackage.description || `${projectName} demo for EasyC++ course`
    );

    // 写入新的 package.json
    fs.writeFileSync(
      packageJsonPath,
      JSON.stringify(newPackage, null, 2),
      'utf8'
    );

    console.log(`✅ 已更新 ${projectName}/package.json`);

  } catch (error) {
    console.log(`❌ 更新 ${projectName} 失败:`, error.message);
  }
});

console.log('\n📝 更新完成！现在可以运行以下命令设置 workspace：');
console.log('   1. pnpm install');
console.log('   2. pnpm start:for-loop  # 测试启动项目');