# 🎬 EasyC++ 动画制作规范

> **重要提示**：当你在 EasyC++ 项目中提到"动画"、"动画demo"、"创建动画"时，Claude 会默认：
> 1. 使用 **Remotion** 框架
> 2. 自动读取并应用 `Template/Demo/for-loop-animation/DESIGN_STYLE.md` 规范
> 3. 使用 VS Code Dark+ 主题和官方锁定的样式系统

---

## 📌 核心规范位置

**设计规范**：`Template/Demo/for-loop-animation/DESIGN_STYLE.md`

**快速指南**：每个 Remotion 项目根目录下的 `REMOTION_GUIDE.md`

---

## 🎨 已锁定的设计元素

以下元素在所有 EasyC++ 教学动画中**强制统一**：

### 1. 背景样式（不可更改）

```typescript
// 官方标准 - 纯黑到深灰渐变
background: `linear-gradient(to bottom,
  #000000 0%,    // 纯黑 - 顶部
  #1a1a1a 40%,   // 深灰 - 中部
  #2d2d30 100%   // 深灰 - 底部
)`
```

### 2. VS Code Dark+ 语法高亮（不可更改）

- 关键字：`#569cd6` （蓝色）
- 类型：`#4ec9b0` （青色）
- 变量：`#9cdcfe` （浅蓝）
- 数字：`#b5cea8` （绿色）

### 3. 布局常量（不可更改）

- 画布：1920×1080
- 格子：100×100px，间距 20px
- 边框：青色 `#569cd6`，粗细 3px
- 字体：Consolas（代码）+ 微软雅黑（UI）

---

## 🚀 创建新动画的标准流程

### 方式一：手动创建（推荐学习）

```bash
# 1. 在 Template/Demo/ 下创建新目录
mkdir -p EasyC++/Template/Demo/my-animation/src

# 2. 复制设计规范（必须）
cp EasyC++/Template/Demo/for-loop-animation/DESIGN_STYLE.md \
   EasyC++/Template/Demo/my-animation/

# 3. 创建 Remotion 项目结构
# package.json, tsconfig.json, remotion.config.ts
# （参考 for-loop-format-animation 项目）

# 4. 编写动画组件，遵循 DESIGN_STYLE.md
```

### 方式二：使用 Claude（推荐）

直接说：

> "创建一个 XXX 的动画demo"

Claude 会自动：
1. 创建新的 Remotion 项目
2. 复制并应用设计规范
3. 生成符合规范的代码模板

---

## ✅ 动画质量检查清单

在提交或渲染动画前，确保：

- [ ] 背景使用官方渐变（不是纯色）
- [ ] 代码使用 VS Code Dark+ 高亮
- [ ] 字体正确（代码 Consolas，UI 微软雅黑）
- [ ] 格子/卡片符合布局常量
- [ ] 状态颜色符合规范
- [ ] 动画流畅，时长合理（通常 15-30 秒）
- [ ] 包含 `DESIGN_STYLE.md` 文件

---

## 📚 典型动画类型

### 已完成

- ✅ **for-loop-animation** - for 循环基础演示
- ✅ **for-loop-format-animation** - for 循环格式详解

### 待开发

- 🔄 **while-loop-animation** - while 循环
- 🔄 **if-else-animation** - 条件判断
- 🔄 **array-animation** - 数组操作
- 🔄 **function-animation** - 函数调用

---

## 🎯 修改现有动画

### 可以修改

- 动画逻辑和流程
- 文字内容（标题、注释、说明）
- 动画时长和缓动参数
- 新增演示示例

### 禁止修改

- ❌ 背景颜色和渐变
- ❌ VS Code Dark+ 语法高亮颜色
- ❌ 布局常量（格子大小、间距等）
- ❌ 字体类型

**原因**：这些元素已锁定，确保所有课程动画视觉一致性。

---

## 🔗 快速链接

- [完整设计规范](./DESIGN_STYLE.md)
- [Remotion 官方文档](https://www.remotion.dev/docs/)
- [VS Code Dark+ Theme](https://code.visualstudio.com/)

---

## 💡 提示

**当你说**：
- "做动画" / "创建动画" / "动画demo"
- "演示 XXX 的执行过程"
- "可视化 XXX 概念"

**Claude 理解为**：
使用 Remotion + 遵循 `DESIGN_STYLE.md` + VS Code Dark+ 主题

无需每次重复说明，Claude 会自动应用规范！