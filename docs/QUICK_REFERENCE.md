# 🎯 EasyC++ 动画项目快速参考

## ⚡ 30秒启动指南

### 方式一：双击启动（推荐）
```
1. 找到项目文件夹
2. 双击 预览.bat
3. 浏览器访问 http://localhost:3000
```

### 方式二：命令行启动
```bash
cd 项目目录
pnpm start
```

## 📁 所有项目列表

| 项目 | 说明 | 启动方式 |
|------|------|----------|
| enum-structure-animation | 枚举结构演示 | 双击 预览.bat |
| for-loop-animation | for循环基础演示 | 双击 预览.bat |
| for-loop-format-animation | for循环格式详解 | 双击 预览.bat |
| foreach-int-vs-ref-animation | foreach int vs int& | 双击 预览.bat |
| foreach-structure-animation | foreach结构演示 | 双击 预览.bat |
| switch-case-animation | switch-case演示 | 双击 预览.bat |
| switch-fallthrough-animation | switch fallthrough演示 | 双击 预览.bat |

## 🛠️ 常用命令

### 在Demo目录
```bash
# 启动特定项目
pnpm start:foreach-int
pnpm start:for-loop
pnpm start:enum

# 创建新项目
create-new-animation.bat 项目名

# 清理和重装
clean-and-reset.bat
```

### 在项目目录
```bash
# 启动预览
预览.bat  # 或 pnpm start

# 渲染视频
../../node_modules/.bin/remotion render src/index.ts Demo
```

## 🎨 项目标准结构

```
项目名/
├── 预览.bat              ← 一键启动
├── README.md             ← 项目说明
├── DESIGN_STYLE.md       ← 设计规范
├── package.json          ← 项目配置
├── src/
│   ├── index.ts          ← 入口
│   ├── Root.tsx          ← 根组件
│   ├── *Demo.tsx         ← 主演示
│   └── components/       ← 组件
└── tsconfig.json         ← TS配置
```

## ⚙️ 服务器管理

### 启动后
- 🌐 访问: http://localhost:3000
- 🔄 自动刷新: 修改代码后自动更新
- 📊 控制台: 显示编译状态和错误
- ⏸️ 停止: Ctrl+C 或关闭窗口

### 多项目
- 项目1: http://localhost:3000
- 项目2: http://localhost:3001
- 项目3: http://localhost:3002

## 🆘 快速故障排除

### 端口被占用
```bash
# 查看占用进程
netstat -ano | findstr :3000

# 结束进程
taskkill /PID 进程ID /F
```

### 依赖问题
```bash
cd Demo目录
pnpm install
```

### 文件缺失
```bash
# 重新生成预览脚本
node create-preview-bat.js 项目目录
```

## 💡 最佳实践

### 开发流程
1. 📂 打开项目文件夹
2. 🖱️ 双击 `预览.bat`
3. 🌐 浏览器自动打开
4. 💻 编辑代码
5. 🔄 自动看到更新
6. ⏹️ 完成后 Ctrl+C

### 代码组织
- 📦 组件放在 `src/components/`
- 🎨 样式放在 `src/styles.ts`
- ⚙️ 配置放在 `src/config.ts`
- 🎬 主动画放在 `src/*Demo.tsx`

## 📞 获取帮助

- 📖 **START_GUIDE.md** - 超简单启动指南
- 📋 **STANDARD_WORKFLOW.md** - 完整工作流程
- 📊 **PROJECT_STATUS_REPORT.md** - 项目状态报告
- 🎨 **DESIGN_STYLE.md** - 设计规范（各项目）

---

**记住: 双击 `预览.bat`，就这么简单！** 🚀